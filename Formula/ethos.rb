# typed: false
# frozen_string_literal: true

class Ethos < Formula
  desc "Identity binding for humans and AI agents"
  homepage "https://github.com/punt-labs/ethos"
  license "MIT"
  version "4.8.0"

  on_macos do
    on_arm do
      url "https://github.com/punt-labs/ethos/releases/download/v4.8.0/ethos-darwin-arm64"
      sha256 "ef5f94b7dd116fa63f69032f14cb80f637d7c022de44176e5c625004ff9fed2a"
    end

    on_intel do
      url "https://github.com/punt-labs/ethos/releases/download/v4.8.0/ethos-darwin-amd64"
      sha256 "4db2321a8af27014c316a5ab20b9abdca323329a51defa48d958d951bea05914"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/punt-labs/ethos/releases/download/v4.8.0/ethos-linux-arm64"
      sha256 "95056d5a4f55710c525ef250cd9b74c0ea624b31de581f5f97f77f0310a5d203"
    end

    on_intel do
      url "https://github.com/punt-labs/ethos/releases/download/v4.8.0/ethos-linux-amd64"
      sha256 "dc3454ed23561f34de2601e120c0d92ab48a4c8d6954b7aedfeb30e1bf19519a"
    end
  end

  def install
    binary = Dir["ethos-*"].first || "ethos"
    bin.install binary => "ethos"
  end

  test do
    assert_match "ethos 4.8.0", shell_output("#{bin}/ethos version")
  end
end
