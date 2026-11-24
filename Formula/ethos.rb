# typed: false
# frozen_string_literal: true

class Ethos < Formula
  desc "Identity binding for humans and AI agents"
  homepage "https://github.com/punt-labs/ethos"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/punt-labs/ethos/releases/download/v5.2.1/ethos-darwin-arm64"
      sha256 "7c0598ef66fb4e23d6c8440e9ecc26356c46565ada78503a5ec9883ae395761c"
    end

    on_intel do
      url "https://github.com/punt-labs/ethos/releases/download/v5.2.1/ethos-darwin-amd64"
      sha256 "b78a27480e57ae1c2a11d4880dc14bebeb63dcd86db0fd85e2dab8c1537efbe3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/punt-labs/ethos/releases/download/v5.2.1/ethos-linux-arm64"
      sha256 "2acfac16f7b05250fd57c73bdc03dc36743f0b001ccd8f140c0f3c1b3150492f"
    end

    on_intel do
      url "https://github.com/punt-labs/ethos/releases/download/v5.2.1/ethos-linux-amd64"
      sha256 "6809260260c06ac9d33bf2f0fe9e4dfb3cedf62557724a71fe6b0c6d1fe25687"
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
