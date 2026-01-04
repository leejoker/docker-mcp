# frozen_string_literal: true

require 'fast_mcp'
require 'docker'

module DockerMCP
  module DockerTools
    # Image info tool
    class ImageList < FastMcp::Tool
      description 'show all docker image info'

      def call
        Docker::Image.all.to_json
      end
    end

    # Image pull tool
    class ImagePull < FastMcp::Tool
      description 'pull an docker image with specified url and then return the image info'

      arguments do
        required(:url).filled(:string).description('docker image url')
      end

      def call(url:)
        image = Docker::Image.create({ 'fromImage' => url })
        image.to_json
      end
    end

    # Image remove by id tool
    class ImageRemoveById < FastMcp::Tool
      description 'remove an docker image by id'

      arguments do
        required(:id).filled(:string).description('docker image id')
      end

      def call(id:)
        image = Docker::Image.get(id)
        Docker::Image.remove(image.id)
        image.to_json
      end
    end

    # Image remove tool
    class ImageRemove < FastMcp::Tool
      description 'remove an docker image with specified url then return the image info, url format is [repo:tag]'

      arguments do
        required(:url).filled(:string).description('docker image url')
      end

      def call(url:)
        Docker::Image.all.each do |image|
          tags = image.info['RepoTags']
          if tags.include?(url)
            Docker::Image.remove(image.id)
            return image.to_json
          end
        end
      end
    end

    # Image save tool
    class ImageSave < FastMcp::Tool
      description 'save or export an docker image to local'

      arguments do
        required(:url).filled(:string).description('docker image url')
        required(:file).filled(:string).description('save file path')
      end

      def call(url:, file:)
        Docker::Image.save(url, file)
        { 'image_path' => file }.to_json
      end
    end
  end
end
