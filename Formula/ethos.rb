# typed: false
# frozen_string_literal: true

class Ethos < Formula
  desc "Identity binding for humans and AI agents"
  homepage "https://github.com/punt-labs/ethos"
  version "4.9.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/punt-labs/ethos/releases/download/v4.9.0/ethos-darwin-arm64"
      sha256 "1a51fc84523de645144d859a0be04136bbb57b00b49025829f41592f919b1bf3"
    end

    on_intel do
      url "https://github.com/punt-labs/ethos/releases/download/v4.9.0/ethos-darwin-amd64"
      sha256 "7249ca0e16db74bf256ad8d7ec5e80e5dd584962f8e148e31f2e53aabea89864"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/punt-labs/ethos/releases/download/v4.9.0/ethos-linux-arm64"
      sha256 "d510d6d9ef9a08d6d2c2b728b93c78fabb2899d426c5e8d405f09f163800fd6c"
    end

    on_intel do
      url "https://github.com/punt-labs/ethos/releases/download/v4.9.0/ethos-linux-amd64"
      sha256 "81d7c31040206b6e5bb9afadfbc1d451d8ebcffadfad501f964b87444f5d29e4"
    end
  end

  def install
    binary = Dir["ethos-*"].first || "ethos"
    bin.install binary => "ethos"
  end

  test do
    assert_match "ethos 4.9.0", shell_output("#{bin}/ethos version")
  end
end
