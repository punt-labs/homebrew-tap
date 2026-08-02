# typed: false
# frozen_string_literal: true

class Ethos < Formula
  desc "Identity binding for humans and AI agents"
  homepage "https://github.com/punt-labs/ethos"
  version "4.10.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/punt-labs/ethos/releases/download/v#{version}/ethos-darwin-arm64"
      sha256 "68560ddd7f84da2d40f2f68e799f6ee16cba7db90de609e0190846c2938506ae"
    end

    on_intel do
      url "https://github.com/punt-labs/ethos/releases/download/v#{version}/ethos-darwin-amd64"
      sha256 "a03e54b20580d8dd7d91a5c942904d938e0a7730957117f931378c8c61d62af0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/punt-labs/ethos/releases/download/v#{version}/ethos-linux-arm64"
      sha256 "ea5fe735fb35900e68e6142191cbf6e830e50cd688bee13c8893c12aec9c76f8"
    end

    on_intel do
      url "https://github.com/punt-labs/ethos/releases/download/v#{version}/ethos-linux-amd64"
      sha256 "cebd307424edd962e15f74a3f8fc728dffbc597a63a7964283108a4ead3f4a5b"
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
