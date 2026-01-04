# frozen_string_literal: true

require_relative '../docker-mcp'
require_relative 'containerd_base'
require_relative 'containerd_namespace'
require_relative '../util/global_utils'

require 'grpc'
require 'github.com/containerd/containerd/api/services/images/v1/images_pb'
require 'github.com/containerd/containerd/api/services/images/v1/images_services_pb'
require 'github.com/containerd/containerd/api/services/transfer/v1/transfer_pb'
require 'github.com/containerd/containerd/api/services/transfer/v1/transfer_services_pb'
require 'github.com/containerd/containerd/api/types/transfer/registry_pb'
require 'github.com/containerd/containerd/api/types/transfer/imagestore_pb'
require 'github.com/containerd/containerd/api/types/platform_pb'

module DockerMCP
  module ContainerdApi
    class Image
      class << self
        def load_stub
          Containerd::Services::Images::V1::Images::Stub.new(ContainerdApi.containerd_sock, :this_channel_is_insecure)
        end

        def create_metadata(ns)
          { 'containerd-namespace' => ns }
        end

        def image_list(ns)
          stub = load_stub
          request = Containerd::Services::Images::V1::ListImagesRequest.new
          resp = stub.list(request, metadata: create_metadata(ns))
          images = JSON.parse(resp.to_json)
          images['images']
        end

        def get_image(ns, image_name)
          stub = load_stub
          get_image_req = Containerd::Services::Images::V1::GetImageRequest.new
          get_image_req.name = image_name
          begin
            get_image_resp = stub.get(get_image_req, metadata: create_metadata(ns))
            get_image_resp.image unless get_image_resp.image.nil?
          rescue => e
            puts e.message
          ensure
            stub.instance_variable_get(:@ch).close if stub.instance_variable_get(:@ch)
          end
        end

        def image_tag(ns, image_name, tag_name)
          stub = load_stub
          image = get_image(ns, image_name)
          unless image.nil?
            image.name = tag_name
            create_image_req = Containerd::Services::Images::V1::CreateImageRequest.new
            create_image_req.image = image
            begin
              resp = stub.create(create_image_req, metadata: create_metadata(ns))
              resp.image
            rescue => e
              puts e.message
            end
          end
        end

        def image_pull(ns, image_name)
          stub = Containerd::Services::Transfer::V1::Transfer::Stub.new(ContainerdApi.containerd_sock, :this_channel_is_insecure)

          source = Containerd::Types::Transfer::OCIRegistry.new
          source.reference = image_name
          source.resolver = Containerd::Types::Transfer::RegistryResolver.new

          destination = Containerd::Types::Transfer::ImageStore.new
          destination.name = image_name

          platform = Containerd::Types::Platform.new
          platform.os = 'linux'
          platform.architecture = 'amd64'
          platforms = Google::Protobuf::RepeatedField.new(:message, Containerd::Types::Platform)
          platforms.push(platform)

          destination.platforms = platforms

          unpack_configure = Containerd::Types::Transfer::UnpackConfiguration.new
          unpack_configure.platform = platform
          unpack_configure.snapshotter = ''
          unpacks = Google::Protobuf::RepeatedField.new(:message, Containerd::Types::Transfer::UnpackConfiguration)
          unpacks.push(unpack_configure)

          destination.unpacks = unpacks

          options = Containerd::Services::Transfer::V1::TransferOptions.new

          source_any = Google::Protobuf::Any.new
          source_any.value = source.to_proto
          source_any.type_url = "#{source.class.descriptor.name}"

          destination_any = Google::Protobuf::Any.new
          destination_any.type_url = "#{destination.class.descriptor.name}"
          destination_any.value = destination.to_proto

          request = Containerd::Services::Transfer::V1::TransferRequest.new
          request.source = source_any
          request.destination = destination_any
          request.options = options

          begin
            stub.transfer(request, metadata: create_metadata(ns))
          rescue => e
            puts e.message
          end
        end
      end
    end
  end
end
