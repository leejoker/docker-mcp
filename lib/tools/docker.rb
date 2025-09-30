# frozen_string_literal: true

require 'fast_mcp'
require 'docker'

module DockerMCP
  module DockerTools
    # A simple tool that responds with the version of docker service
    class DockerVersion < FastMcp::Tool
      description 'show the version of docker service'

      def call
        Docker.version
      end
    end

    class DockerInfo < FastMcp::Tool
      description 'show the info of docker service'

      def call
        Docker.info
      end
    end
  end
end
