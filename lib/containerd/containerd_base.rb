# frozen_string_literal: true

module DockerMCP
  module ContainerdApi
    def self.containerd_sock
      'unix:/var/run/containerd/containerd.sock'
    end
  end
end
