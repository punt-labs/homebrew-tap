# typed: false
# frozen_string_literal: true

class Ethos < Formula
  desc "Identity binding for humans and AI agents"
  homepage "https://github.com/punt-labs/ethos"
  license "MIT"
  version "4.7.0"

  on_macos do
    on_arm do
      url "https://github.com/punt-labs/ethos/releases/download/v4.7.0/ethos-darwin-arm64"
      sha256 "04a5a216f995735631eaef406dcd6e0fac424ed5dd038142394a3b5fde0c1601"
    end

    on_intel do
      url "https://github.com/punt-labs/ethos/releases/download/v4.7.0/ethos-darwin-amd64"
      sha256 "e267f7f443db0117706fdb7f45ef0787f3f3fe58f56d73df5de0a670a0c04dcb"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/punt-labs/ethos/releases/download/v4.7.0/ethos-linux-arm64"
      sha256 "5a4a0618dcbfe6bd31de6ab5f0eadd86b4123ffb6d2ef489eb07a64918248c2a"
    end

    on_intel do
      url "https://github.com/punt-labs/ethos/releases/download/v4.7.0/ethos-linux-amd64"
      sha256 "3005363c624c2001abe6db9adde2cd318020e7d6ee7e5f29c9879295149ee156"
    end
  end

  def install
    binary = Dir["ethos-*"].first || "ethos"
    bin.install binary => "ethos"
  end

  test do
    assert_match "ethos 4.7.0", shell_output("#{bin}/ethos version")
  end
end
