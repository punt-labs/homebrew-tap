# typed: false
# frozen_string_literal: true

class Ethos < Formula
  desc "Identity binding for humans and AI agents"
  homepage "https://github.com/punt-labs/ethos"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/punt-labs/ethos/releases/download/v5.2.0/ethos-darwin-arm64"
      sha256 "7b506bcf72443d7919ab695cec213d4bc567d5d6280c8bd736361ba542bd56bb"
    end

    on_intel do
      url "https://github.com/punt-labs/ethos/releases/download/v5.2.0/ethos-darwin-amd64"
      sha256 "ed63c684e5673619b095da3d68384fce7826ca5242eb219391207df50b1144d9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/punt-labs/ethos/releases/download/v5.2.0/ethos-linux-arm64"
      sha256 "49f5935ebca56711352d96742416acfb4ac430a36de175df27eb347fe37bf1fb"
    end

    on_intel do
      url "https://github.com/punt-labs/ethos/releases/download/v5.2.0/ethos-linux-amd64"
      sha256 "250e4d4d642c64696df96eaf1f06451cc7bd95138cf11d3811b96f0b41a0288d"
    end
  end

  def install
    binary = Dir["ethos-*"].first || "ethos"
    bin.install binary => "ethos"
  end

  test do
    assert_match "ethos #{version}", shell_output("#{bin}/ethos version")
  end
end
