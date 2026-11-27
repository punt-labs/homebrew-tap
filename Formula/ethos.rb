# typed: false
# frozen_string_literal: true

class Ethos < Formula
  desc "Identity binding for humans and AI agents"
  homepage "https://github.com/punt-labs/ethos"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/punt-labs/ethos/releases/download/v5.3.1/ethos-darwin-arm64"
      sha256 "0e7a88b80aa9eedf3aa59af85e83bd32375803400634769b921a81f1dca9696c"
    end

    on_intel do
      url "https://github.com/punt-labs/ethos/releases/download/v5.3.1/ethos-darwin-amd64"
      sha256 "d492018a02783157399deab45e51baf4f52bea0e92328c5a88fc920f211657cc"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/punt-labs/ethos/releases/download/v5.3.1/ethos-linux-arm64"
      sha256 "77219aca91cb2a1e1d81fc5780ef9823f1f0200556d97a8f44e6e5228f854034"
    end

    on_intel do
      url "https://github.com/punt-labs/ethos/releases/download/v5.3.1/ethos-linux-amd64"
      sha256 "9cde93846eea9b1dba52ffd332c6b312d5e1f2d5d1c3593feb034fc96e1aa935"
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
