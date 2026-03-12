# typed: false
# frozen_string_literal: true

class McpProxy < Formula
  desc "Lightweight proxy bridging MCP stdio to shared daemon processes"
  homepage "https://github.com/punt-labs/mcp-proxy"
  license "MIT"
  version "0.1.0"

  on_macos do
    on_arm do
      url "https://github.com/punt-labs/mcp-proxy/releases/download/v0.1.0/mcp-proxy-darwin-arm64"
      sha256 "PLACEHOLDER"
    end

    on_intel do
      url "https://github.com/punt-labs/mcp-proxy/releases/download/v0.1.0/mcp-proxy-darwin-amd64"
      sha256 "PLACEHOLDER"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/punt-labs/mcp-proxy/releases/download/v0.1.0/mcp-proxy-linux-arm64"
      sha256 "PLACEHOLDER"
    end

    on_intel do
      url "https://github.com/punt-labs/mcp-proxy/releases/download/v0.1.0/mcp-proxy-linux-amd64"
      sha256 "PLACEHOLDER"
    end
  end

  def install
    binary = Dir["mcp-proxy-*"].first || "mcp-proxy"
    bin.install binary => "mcp-proxy"
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/mcp-proxy 2>&1", 2)
  end
end
