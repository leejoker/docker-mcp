# frozen_string_literal: true

module DockerMCP
  # DockerMCP::ContainerdApi
  module ContainerdApi
    def self.containerd_sock
      'unix:/var/run/containerd/containerd.sock'
    end
  end
end
