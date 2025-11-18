# frozen_string_literal: true

module DockerMCP
  class GlobalUtils
    class << self
      def container_type
        ENV['CONTAINER_TYPE']
      end
    end
  end
end