# typed: false
# frozen_string_literal: true

class Ethos < Formula
  desc "Identity binding for humans and AI agents"
  homepage "https://github.com/punt-labs/ethos"
  version "4.13.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/punt-labs/ethos/releases/download/v#{version}/ethos-darwin-arm64"
      sha256 "67a57739e2dc18d662e6208449f02716dd1d82d8ee84ecfd0935b0552e981620"
    end

    on_intel do
      url "https://github.com/punt-labs/ethos/releases/download/v#{version}/ethos-darwin-amd64"
      sha256 "4ec53d28ac675f0ce110769e42dd9408b1e0c76181fef0686f5e737ce5556eda"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/punt-labs/ethos/releases/download/v#{version}/ethos-linux-arm64"
      sha256 "bbf9bd0e70fc83b87ab5ff8575c7473c4949ca10bd19a433d79b295599a68c96"
    end

    on_intel do
      url "https://github.com/punt-labs/ethos/releases/download/v#{version}/ethos-linux-amd64"
      sha256 "e72f75784105180cb5c9de3fd4e822f36f67e83afae55df625eaeec56b2b6c9b"
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
