# frozen_string_literal: true

require 'fast_mcp'
require_relative '../tools/hello'
require_relative '../tools/docker'
require_relative '../tools/image'
require_relative '../tools/container'

module DockerMCP
  # Simple Rack application with MCP middleware
  class StdioServer
    def find_all_fast_mcp_tool_subclasses
      ObjectSpace.each_object(Class).select do |klass|
        klass < FastMcp::Tool
      end
    end

    def start_server
      server = FastMcp::Server.new(name: 'docker-mcp-server', version: '1.0.0')
      # register tools
      classes = find_all_fast_mcp_tool_subclasses
      classes.each do |klass|
        server.register_tool(klass)
      end

      server.start
    end
  end
end
