# typed: false
# frozen_string_literal: true

class Ethos < Formula
  desc "Identity binding for humans and AI agents"
  homepage "https://github.com/punt-labs/ethos"
  license "MIT"
  version "4.5.0"

  on_macos do
    on_arm do
      url "https://github.com/punt-labs/ethos/releases/download/v4.5.0/ethos-darwin-arm64"
      sha256 "2e556799f417feb6c2481e08db9aacae5f90591fd049d176f060a81e952b9f07"
    end

    on_intel do
      url "https://github.com/punt-labs/ethos/releases/download/v4.5.0/ethos-darwin-amd64"
      sha256 "2282f8d8b5635f7f0da2e91e79e9fdf477582b8550c49fcfaeb3453b2d9618bc"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/punt-labs/ethos/releases/download/v4.5.0/ethos-linux-arm64"
      sha256 "a51fcaa6b5b98077ecb6b7a7a5110d0bc30a55cfd2e5804a11897f1bce988e3d"
    end

    on_intel do
      url "https://github.com/punt-labs/ethos/releases/download/v4.5.0/ethos-linux-amd64"
      sha256 "4d77affb4bc8c9d95c591d56605d3eed1dfcc83cfd2cf0727a652ad486033b73"
    end
  end

  def install
    binary = Dir["ethos-*"].first || "ethos"
    bin.install binary => "ethos"
  end

  test do
    assert_match "ethos 4.5.0", shell_output("#{bin}/ethos version")
  end
end
