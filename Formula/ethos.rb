# typed: false
# frozen_string_literal: true

class Ethos < Formula
  desc "Identity binding for humans and AI agents"
  homepage "https://github.com/punt-labs/ethos"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/punt-labs/ethos/releases/download/v5.2.2/ethos-darwin-arm64"
      sha256 "2b915a7ab02cd6dca9473fd30b28fd90e2c8e693b8d760893f7bb3945984697b"
    end

    on_intel do
      url "https://github.com/punt-labs/ethos/releases/download/v5.2.2/ethos-darwin-amd64"
      sha256 "c03ef0a62cb93a1394f3118aa99b0a93a7dea7f29e8c6e5257779081c0cc89b3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/punt-labs/ethos/releases/download/v5.2.2/ethos-linux-arm64"
      sha256 "a0c62f482bb88340ee6991dfd3dc212720eb857991aad482698bf19da5641277"
    end

    on_intel do
      url "https://github.com/punt-labs/ethos/releases/download/v5.2.2/ethos-linux-amd64"
      sha256 "86190b824e3156548fb1aaea6f494ebb546dc657685e80674346985587f11f6d"
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
