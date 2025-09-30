# frozen_string_literal: true

require_relative 'version'

Gem::Specification.new do |s|
  s.name = 'docker-mcp'
  s.version = DockerMCP::VERSION
  s.bindir = 'bin'
  s.executables = %w[docker-mcp]
  s.summary = 'docker mcp server'
  s.description = 'docker mcp server'
  s.authors = ['leejoker']
  s.email = '1056650571@qq.com'
  s.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  s.extra_rdoc_files = %w[README.md LICENSE]
  s.homepage = 'https://github.com/leejoker/docker-mcp'
  s.license = 'MIT'

  s.add_dependency 'docker-api'
  s.add_dependency 'fast-mcp'
end
