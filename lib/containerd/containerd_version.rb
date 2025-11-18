# frozen_string_literal: true

require 'grpc'
require_relative 'containerd_base'
require_relative 'api/services/version/v1/version_services_pb'
require_relative 'api/services/version/v1/version_pb'

module DockerMCP
  module ContainerdApi
    class Version
      class << self
        def version
          stub = Containerd::Services::Version::V1::Version::Stub.new(ContainerdApi.containerd_sock, :this_channel_is_insecure)
          resp = stub.version(Google::Protobuf::Empty.new)
          resp.to_json
        end
      end
    end
  end
end

puts DockerMCP::ContainerdApi::Version.version