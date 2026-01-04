# frozen_string_literal: true

module DockerMCP
  class GlobalUtils
    class << self
      def container_type
        ENV['CONTAINER_TYPE']
      end

      def namespace_name
        ENV['NAMESPACE_NAME']
      end
    end
  end
end
