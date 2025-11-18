# frozen_string_literal: true

require 'grpc'
require_relative 'containerd_base'
require_relative 'containerd_namespace'
require_relative 'api/services/images/v1/images_pb'
require_relative 'api/services/images/v1/images_services_pb'

module DockerMCP
  module ContainerdApi
    class Image
      class << self
        def load_stub
          Containerd::Services::Images::V1::Images::Stub.new(ContainerdApi.containerd_sock, :this_channel_is_insecure)
        end

        def image_list
          stub = load_stub
          image_map = {}
          namespaces = ContainerdApi::Namespace.namespace_list
          namespaces.each do |namespace|
            namespace_name = namespace["name"]
            request = Containerd::Services::Images::V1::ListImagesRequest.new
            metadata = { 'containerd-namespace' => namespace_name }
            resp = stub.list(request, metadata: metadata)
            images = JSON.parse(resp.to_json)
            image_map[namespace_name] = images['images']
          end
          image_map
        end
      end
    end
  end
end