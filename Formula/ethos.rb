# typed: false
# frozen_string_literal: true

class Ethos < Formula
  desc "Identity binding for humans and AI agents"
  homepage "https://github.com/punt-labs/ethos"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/punt-labs/ethos/releases/download/v5.2.4/ethos-darwin-arm64"
      sha256 "a0379c836030ae99c72ac7d82af6834f2f25a099be966cfdae0739e06276fd75"
    end

    on_intel do
      url "https://github.com/punt-labs/ethos/releases/download/v5.2.4/ethos-darwin-amd64"
      sha256 "acede2a247353054975661be3ab01396393ef891f7ae2c33f1f98fb9964deaa0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/punt-labs/ethos/releases/download/v5.2.4/ethos-linux-arm64"
      sha256 "d3adba838c734db83eeb2743075626b5538c49d36fa0b4065b49128e020ffa54"
    end

    on_intel do
      url "https://github.com/punt-labs/ethos/releases/download/v5.2.4/ethos-linux-amd64"
      sha256 "a9d23416923ac839d639fe83d379ffd151ed0055e4d326505c7bd51957f1d277"
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
