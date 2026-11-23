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
        binary.write_text('#!/bin/sh\nexit 0\n')
        binary.chmod(0o755)
        self.assertEqual(self.run_hook(), '')

    def test_explicit_kill_switch_is_quiet(self):
        (self.home / '.punt-hooks-kill').touch()
        self.assertEqual(self.run_hook(), '')


if __name__ == '__main__':
    unittest.main()
