import json
import os
from pathlib import Path
import subprocess
import tempfile
import unittest


ROOT = Path(__file__).resolve().parents[1]


class AgentRuntimeTest(unittest.TestCase):
    def setUp(self):
        (ROOT / '.tmp').mkdir(exist_ok=True)
        self.temp = tempfile.TemporaryDirectory(dir=ROOT / '.tmp')
        self.addCleanup(self.temp.cleanup)
        self.home = Path(self.temp.name)
        settings = json.loads((ROOT / '.claude/settings.json').read_text())
        self.command = settings['hooks']['PostToolUse'][0]['hooks'][0]['command']

    def run_hook(self):
        result = subprocess.run(
            ['/bin/sh', '-c', self.command], input='', capture_output=True,
            text=True, timeout=5,
            env={**os.environ, 'HOME': str(self.home), 'PATH': str(self.home),
                 'CLAUDE_PROJECT_DIR': str(ROOT)},
        )
        self.assertEqual(result.returncode, 0, result.stderr)
        return result.stdout

    def test_missing_binary_emits_advisory_with_empty_input(self):
        output = json.loads(self.run_hook())['hookSpecificOutput']
        self.assertEqual(output['hookEventName'], 'PostToolUse')
        self.assertIn('checks are not running', output['additionalContext'])

    def test_available_binary_is_quiet(self):
        binary = self.home / 'ethos'
        binary.write_text('#!/bin/sh\necho "post-edit input: tool_input.file_path is required"\n')
        binary.chmod(0o755)
        self.assertEqual(self.run_hook(), '')

    def test_old_binary_emits_advisory(self):
        binary = self.home / 'ethos'
        binary.write_text('#!/bin/sh\necho "Usage: ethos hook [command]"\n')
        binary.chmod(0o755)
        output = json.loads(self.run_hook())['hookSpecificOutput']
        self.assertIn('incompatible', output['additionalContext'])

    def test_failed_invocation_emits_advisory(self):
        binary = self.home / 'ethos'
        binary.write_text('#!/bin/sh\necho "ethos hook post-edit"\nexit 1\n')
        binary.chmod(0o755)
        output = json.loads(self.run_hook())['hookSpecificOutput']
        self.assertIn('checks are not running', output['additionalContext'])

    def test_working_help_but_broken_invocation_emits_advisory(self):
        binary = self.home / 'ethos'
        binary.write_text(
            '#!/bin/sh\nif [ "${3-}" = --help ]; then\n'
            'echo "ethos hook post-edit"\nelse\nexit 1\nfi\n'
        )
        binary.chmod(0o755)
        output = json.loads(self.run_hook())['hookSpecificOutput']
        self.assertIn('checks are not running', output['additionalContext'])

    def test_explicit_kill_switch_is_quiet(self):
        (self.home / '.punt-hooks-kill').touch()
        self.assertEqual(self.run_hook(), '')


class AgentSetupTest(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.home = Path(self.temp.name)
        self.trace = self.home / 'trace'
        self.command('ethos', r'''
if [ "$1" = version ]; then
  printf 'ethos %s\n' "$ETHOS_VERSION"
elif [ "$1" = enable ]; then
  printf '%s\n' 'ethos enable' >> "$TRACE"
elif [ "${3-}" = --help ]; then
  printf 'ethos hook %s\n' "$2"
else
  printf '%s\n' 'post-edit input: tool_input.file_path is required'
fi
''')
        self.command('git', 'printf "%s\\n" "$HOME/pre-commit"\n')
        self.command('pre-commit', r'''
# _cap=$("$ethos_bin" hook pre-commit;
printf '%s\n' pre-commit >> "$TRACE"
''')

    def command(self, name, body):
        path = self.home / name
        path.write_text('#!/bin/sh\n' + body)
        path.chmod(0o755)

    def run_setup(self, brew_exit=None, version='5.3.2'):
        if brew_exit is not None:
            self.command('brew', 'printf "brew %s\\n" "$*" >> "$TRACE"\n' + f'exit {brew_exit}\n')
        return subprocess.run(
            ['/bin/sh', str(ROOT / 'scripts/setup-agent-checks.sh')],
            cwd=self.home, capture_output=True, text=True, timeout=5,
            env={'HOME': str(self.home), 'PATH': f'{self.home}{os.pathsep}{os.defpath}',
                 'TRACE': str(self.trace), 'ETHOS_VERSION': version},
        )

    def test_setup_rejects_5_3_1_before_provisioning(self):
        result = self.run_setup(brew_exit=0, version='5.3.1')
        self.assertEqual(result.returncode, 1)
        self.assertIn('Ethos v5.3.2 or later', result.stderr)
        self.assertFalse(self.trace.exists())

    def test_setup_provisions_style_gems_before_enabling(self):
        result = self.run_setup(brew_exit=0)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(self.trace.read_text().splitlines(), [
            'brew install-bundler-gems --add-groups=style', 'ethos enable', 'pre-commit',
        ])

    def test_failed_provisioning_does_not_enable(self):
        result = self.run_setup(brew_exit=1)
        self.assertEqual(result.returncode, 1)
        self.assertIn('failed to install Homebrew style gems; no integration was installed', result.stderr)
        self.assertEqual(self.trace.read_text().splitlines(), ['brew install-bundler-gems --add-groups=style'])

    def test_missing_brew_does_not_enable(self):
        result = self.run_setup()
        self.assertEqual(result.returncode, 1)
        self.assertIn('failed to install Homebrew style gems; no integration was installed', result.stderr)
        self.assertFalse(self.trace.exists())


if __name__ == '__main__':
    unittest.main()
