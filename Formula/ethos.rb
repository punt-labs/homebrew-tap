# typed: false
# frozen_string_literal: true

class Ethos < Formula
  desc "Identity binding for humans and AI agents"
  homepage "https://github.com/punt-labs/ethos"
  license "MIT"
  version "0.3.4"

  on_macos do
    on_arm do
      url "https://github.com/punt-labs/ethos/releases/download/v0.3.4/ethos-darwin-arm64"
      sha256 "9b4d20a593bcc5057b37acdec25cdc507c5bdc5387dd30dc4d4735d2b5cca96e"
    end

    on_intel do
      url "https://github.com/punt-labs/ethos/releases/download/v0.3.4/ethos-darwin-amd64"
      sha256 "d3126926b46ab4d28958e3736f4a89c1908689f8a6c66837188357005c78cb62"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/punt-labs/ethos/releases/download/v0.3.4/ethos-linux-arm64"
      sha256 "00da37f5457b2d8ea5f5640d353de892546a5fa4d7de2075aee2b195bc62baf6"
    end

    on_intel do
      url "https://github.com/punt-labs/ethos/releases/download/v0.3.4/ethos-linux-amd64"
      sha256 "a422531c8c7150d4d81c88d823385fcecd254388c96daf7a96ce732a22fe01ba"
    end
  end

  def install
    binary = Dir["ethos-*"].first || "ethos"
    bin.install binary => "ethos"
  end

  test do
    assert_match "ethos 0.3.4", shell_output("#{bin}/ethos version")
  end
end
