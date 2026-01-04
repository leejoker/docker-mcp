# frozen_string_literal: true

require_relative '../docker-mcp'
require_relative 'containerd_base'

require 'grpc'
require 'github.com/containerd/containerd/api/services/version/v1/version_pb'
require 'github.com/containerd/containerd/api/services/version/v1/version_services_pb'

module DockerMCP
  module ContainerdApi
    # Version
    class Version
      class << self
        def version
          stub = Containerd::Services::Version::V1::Version::Stub.new(ContainerdApi.containerd_sock,
                                                                      :this_channel_is_insecure)
          resp = stub.version(Google::Protobuf::Empty.new)
          resp.to_json
        end
      end
    end
  end
end
