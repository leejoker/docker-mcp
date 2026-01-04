# frozen_string_literal: true

module DockerMCP
  class GlobalUtils
    class << self
      def container_type
        ct = ENV['CONTAINER_TYPE']
        if ct.nil?
          'docker'
        else
          ct
        end
      end

      def namespace_name
        ns = ENV['NAMESPACE_NAME']
        if ns.nil?
          'default'
        else
          ns
        end
      end
    end
  end
end
