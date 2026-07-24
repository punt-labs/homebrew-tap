# typed: false
# frozen_string_literal: true

class Ethos < Formula
  desc "Identity binding for humans and AI agents"
  homepage "https://github.com/punt-labs/ethos"
  license "MIT"
  version "4.4.1"

  on_macos do
    on_arm do
      url "https://github.com/punt-labs/ethos/releases/download/v4.4.1/ethos-darwin-arm64"
      sha256 "a08d289b30a3a0b2225d88082841c59015a979bbd1d2f1d5e7f3dc4a0a56b7f6"
    end

    on_intel do
      url "https://github.com/punt-labs/ethos/releases/download/v4.4.1/ethos-darwin-amd64"
      sha256 "fe927a4d0c60be3714426d100e40a8f6dadc0432eb6b6229c3270ea05d81ac1f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/punt-labs/ethos/releases/download/v4.4.1/ethos-linux-arm64"
      sha256 "d1efa72c19964e5f757c2929ad9807c35bee56bfc47b409881b652bb691f6cb9"
    end

    on_intel do
      url "https://github.com/punt-labs/ethos/releases/download/v4.4.1/ethos-linux-amd64"
      sha256 "0a43b444404225d873d3221219800ad85fa9b68cc9715c5e46853a3deef744aa"
    end
  end

  def install
    binary = Dir["ethos-*"].first || "ethos"
    bin.install binary => "ethos"
  end

  test do
    assert_match "ethos 4.4.1", shell_output("#{bin}/ethos version")
  end
end
