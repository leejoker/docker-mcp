# frozen_string_literal: true

require_relative '../docker-mcp'

require 'fast_mcp'
require 'docker'
require 'containerd/containerd_version'
require 'util/global_utils'

module DockerMCP
  module DockerTools
    # A simple tool that responds with the version of docker service
    class DockerVersion < FastMcp::Tool
      description 'show the version of docker/containerd service'

      def call
        ct = GlobalUtils.container_type
        if ct == 'docker'
          Docker.version
        else
          ContainerdApi::Version.version
        end
      end
    end

    # A simple tool that responds with the info of docker service
    class DockerInfo < FastMcp::Tool
      description 'show the info of docker service'

      def call
        ct = GlobalUtils.container_type
        return unless ct == 'docker'

        Docker.info
      end
    end
  end
end
