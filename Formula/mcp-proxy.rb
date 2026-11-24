# typed: false
# frozen_string_literal: true

class McpProxy < Formula
  desc "Lightweight proxy bridging MCP stdio to shared daemon processes"
  homepage "https://github.com/punt-labs/mcp-proxy"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/punt-labs/mcp-proxy/releases/download/v0.1.0/mcp-proxy-darwin-arm64"
      sha256 "581506a4d844b14267d9fa4a4f51e18e0216f30359a4567e31bb2a1491d5b253"
    end

    on_intel do
      url "https://github.com/punt-labs/mcp-proxy/releases/download/v0.1.0/mcp-proxy-darwin-amd64"
      sha256 "ba3e334544ba33a7474d3d1b5e0809cf55918e4526eb68ddc15b17f70f023d05"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/punt-labs/mcp-proxy/releases/download/v0.1.0/mcp-proxy-linux-arm64"
      sha256 "0ca480a78e9ad6441d06e58fb1a4b30ba345f99333456f517387bf9b404c32b7"
    end

    on_intel do
      url "https://github.com/punt-labs/mcp-proxy/releases/download/v0.1.0/mcp-proxy-linux-amd64"
      sha256 "93bb6891a4c27208b3521c152de1291eb86302ed2d3d8013e74634a5baf935d7"
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
