# typed: false
# frozen_string_literal: true

class Ethos < Formula
  desc "Identity binding for humans and AI agents"
  homepage "https://github.com/punt-labs/ethos"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/punt-labs/ethos/releases/download/v5.2.3/ethos-darwin-arm64"
      sha256 "f2c078d9161ad96092d9b3fd98431b5ad13573415058d1f36406249cb48e3502"
    end

    on_intel do
      url "https://github.com/punt-labs/ethos/releases/download/v5.2.3/ethos-darwin-amd64"
      sha256 "78d496a691048e6cbce8a709ef5e66be7dbc92438c6ff85e943aac238b7b2125"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/punt-labs/ethos/releases/download/v5.2.3/ethos-linux-arm64"
      sha256 "edfb8cdfdb4a3641cf45f3faa7abbf433c7f7546dc26f9043a8cac6386fb30b3"
    end

    on_intel do
      url "https://github.com/punt-labs/ethos/releases/download/v5.2.3/ethos-linux-amd64"
      sha256 "ae9f4f1a3230d2d6017e260d5fd874eb2fc76f337c72cd6f88b4357493370a1c"
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
