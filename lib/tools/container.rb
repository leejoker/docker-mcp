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

    class ContainerCreate < FastMcp::Tool
      description 'create container with image name and tag'

      arguments do
        required(:image).filled(:string).description('image name')
        required(:tag).filled(:string).description('image tag')
        required(:port).filled(:string).description('port')
        required(:target_port).filled(:string).description('target port')
      end

      def call(image:, tag:, port:, target_port:)
        begin
          # 创建容器配置
          container_config = {
            'Image' => "#{image}:#{tag}",
            'Tty' => true, # 对应 -t 参数
            'OpenStdin' => true, # 对应 -i 参数
            'AttachStdin' => true,
            'AttachStdout' => true,
            'AttachStderr' => true,
            'HostConfig' => {
              'AutoRemove' => true, # 对应 --rm 参数
              'PortBindings' => {
                "#{port}/tcp" => [
                  {
                    'HostPort' => "#{target_port}"
                  }
                ]
              }
            }
          }
          # 创建容器
          container = Docker::Container.create(container_config)
          puts "容器创建成功，ID: #{container.id}"
          # 启动容器
          container.start
          puts "容器启动成功"
          container.to_json
        rescue Docker::Error::NotFoundError => e
          puts "错误：镜像不存在 - #{e.message}"
        rescue Docker::Error::ServerError => e
          puts "Docker服务器错误：#{e.message}"
        rescue StandardError => e
          puts "发生错误：#{e.message}"
        end
      end
    end
  end
end
