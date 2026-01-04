# frozen_string_literal: true

require_relative '../docker-mcp'
require_relative 'containerd_base'

require 'grpc'
require 'json'
require 'github.com/containerd/containerd/api/services/namespaces/v1/namespace_pb'
require 'github.com/containerd/containerd/api/services/namespaces/v1/namespace_services_pb'

module DockerMCP
  module ContainerdApi
    # Namespace
    class Namespace
      class << self
        def load_stub
          Containerd::Services::Namespaces::V1::Namespaces::Stub.new(ContainerdApi.containerd_sock,
                                                                     :this_channel_is_insecure)
        end

        def namespace_list
          stub = load_stub
          resp = stub.list(Containerd::Services::Namespaces::V1::ListNamespacesRequest.new)
          namespaces = JSON.parse(resp.to_json)
          namespaces['namespaces']
        end
      end
    end
  end
end
