# typed: false
# frozen_string_literal: true

class Ethos < Formula
  desc "Identity binding for humans and AI agents"
  homepage "https://github.com/punt-labs/ethos"
  license "MIT"
  version "4.6.0"

  on_macos do
    on_arm do
      url "https://github.com/punt-labs/ethos/releases/download/v4.6.0/ethos-darwin-arm64"
      sha256 "2f136dcfbc9b292c1418a381307aee9e946ff48459e8ef19b8a2e6eb91831f5c"
    end

    on_intel do
      url "https://github.com/punt-labs/ethos/releases/download/v4.6.0/ethos-darwin-amd64"
      sha256 "9fdbd574f3109021f18d07563c6f189fa9a0b3c618a06896960b9ee1a0fdb003"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/punt-labs/ethos/releases/download/v4.6.0/ethos-linux-arm64"
      sha256 "b788f13c7c7bb1f4510c72b64b629376cca320b9c871fd40e5e49afc344e3bf6"
    end

    on_intel do
      url "https://github.com/punt-labs/ethos/releases/download/v4.6.0/ethos-linux-amd64"
      sha256 "f39435c5889a7a2008b098ae3f2da85da23754ac12a8702361ca967a89682f28"
    end
  end

  def install
    binary = Dir["ethos-*"].first || "ethos"
    bin.install binary => "ethos"
  end

  test do
    assert_match "ethos 4.6.0", shell_output("#{bin}/ethos version")
  end
end
