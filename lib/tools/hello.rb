# frozen_string_literal: true

require 'fast_mcp'

module DockerMCP
  # A simple tool that responds with 'pong' when 'ping' is called
  class PingTool < FastMcp::Tool
    description 'ping the server to check it healthy status'

    def call
      'pong'
    end
  end
end
