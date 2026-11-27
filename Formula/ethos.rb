# typed: false
# frozen_string_literal: true

class Ethos < Formula
  desc "Identity binding for humans and AI agents"
  homepage "https://github.com/punt-labs/ethos"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/punt-labs/ethos/releases/download/v5.3.2/ethos-darwin-arm64"
      sha256 "b0633a3130b5fbcb7f2c5fd8edd936b280b0d0dc7f35e8224364f0c60b51319c"
    end

    on_intel do
      url "https://github.com/punt-labs/ethos/releases/download/v5.3.2/ethos-darwin-amd64"
      sha256 "f27520f3b744f3f8f620c677993b893e54af5b1af25e0a780d60c3f30f8ae874"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/punt-labs/ethos/releases/download/v5.3.2/ethos-linux-arm64"
      sha256 "c2c3aa2106cea95ead6e6d395c3bcab13f35b60a4e4a2c8cf95789b9a2ee2662"
    end

    on_intel do
      url "https://github.com/punt-labs/ethos/releases/download/v5.3.2/ethos-linux-amd64"
      sha256 "dad747374b1cb5814cd561c10bbafb22dae1007aa3a6f81878df8ca832ae7634"
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
