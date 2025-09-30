# frozen_string_literal: true

require 'fast_mcp'
require 'docker'

module DockerMCP
  module DockerTools
    class ContainerList < FastMcp::Tool
      description 'show all docker containers info'

      def call
        Docker::Container.all.to_json
      end
    end

    class ContainerInfo < FastMcp::Tool
      description 'show container info by container id'

      arguments do
        required(:id).filled(:string).description('container id')
      end

      def call(id:)
        Docker::Container.get(id).to_json
      end
    end
  end
end
