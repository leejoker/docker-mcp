# Docker-MCP

Docker-MCP is a Ruby-based server that provides Model Context Protocol (MCP) tools for interacting with Docker services. It allows external clients to perform Docker operations such as managing images, containers, and getting Docker service information through a standardized MCP interface.

阅读此文档的其他语言版本: [中文版](README.zh.md)

## Features

- **Docker Operations**: Manage Docker images and containers remotely
- **Service Information**: Get Docker service version and system information
- **MCP Standard**: Implements the Model Context Protocol for standardized interactions
- **Container Ready**: Dockerfile and docker-compose configuration included
- **Stdio Interface**: Communicates via standard input/output streams

## Prerequisites

- Ruby 3.4+ (uses the `timbru31/ruby-node:3.4-slim-iron` Docker base image)
- Docker API access
- Node.js (for supergateway dependency)

## Installation

### Local Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/leejoker/docker-mcp.git
   cd docker-mcp
   ```

2. Install dependencies:
   ```bash
   gem install docker-mcp
   # or
   bundle install
   ```

### Using Docker

Build and run the service using Docker:

```bash
# Build the image
docker build -t docker-mcp:1.0.0 .

# Run the container
docker run -d --name docker-mcp -p 8080:8080 --restart unless-stopped docker-mcp:1.0.0
```

Or use the provided docker-compose file:

```bash
docker-compose up -d
```

## Configuration

The service runs on port 8080 by default and is exposed via the supergateway with the following endpoints:
- Base URL: `http://localhost:8080`
- SSE Path: `/sse`
- Message Path: `/message`

## Available Tools

The server provides the following Docker MCP tools:

### Health Check
- **PingTool**: Check server health status
  - Description: `ping the server to check it healthy status`
  - Returns: `'pong'`

### Docker Service Information
- **DockerVersion**: Get Docker service version
  - Description: `show the version of docker service`
  - Returns: Docker version information

- **DockerInfo**: Get Docker service information
  - Description: `show the info of docker service`
  - Returns: Docker system information

### Image Management
- **ImageList**: List all Docker images
  - Description: `show all docker image info`
  - Returns: JSON array of image information

- **ImagePull**: Pull a Docker image by URL
  - Description: `pull an docker image with specified url and then return the image info`
  - Arguments: `url` (required string) - Docker image URL
  - Returns: Image information after pulling

- **ImageRemove**: Remove an image by URL
  - Description: `remove an docker image with specified url then return the image info, url format is [repo:tag]`
  - Arguments: `url` (required string) - Docker image URL in format `repo:tag`
  - Returns: Information about the removed image

- **ImageRemoveById**: Remove an image by ID
  - Description: `remove an docker image by id`
  - Arguments: `id` (required string) - Docker image ID
  - Returns: Information about the removed image

### Container Management
- **ContainerList**: List all Docker containers
  - Description: `show all docker containers info`
  - Returns: JSON array of container information

- **ContainerInfo**: Get information about a specific container
  - Description: `show container info by container id`
  - Arguments: `id` (required string) - Container ID
  - Returns: Detailed container information

## Architecture

The project is structured as follows:

```
lib/
├── server/
│   └── stdio_server.rb    # Main MCP server implementation
└── tools/
    ├── hello.rb          # Health check tool
    ├── docker.rb         # Docker service information tools
    ├── image.rb          # Image management tools
    └── container.rb      # Container management tools
```

The server uses:
- `fast-mcp` gem for MCP protocol implementation
- `docker-api` gem for Docker interactions
- `supergateway` for stdio-to-HTTP communication

## Development

To run the server locally for development:

1. Install dependencies:
   ```bash
   bundle install
   npm install -g supergateway
   ```

2. Run the server:
   ```bash
   ./bin/docker-mcp
   ```

This will start the stdio server which can be connected to via supergateway for HTTP access.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Author

- **leejoker** - [GitHub](https://github.com/leejoker)

## Acknowledgments

- Built with [fast-mcp](https://github.com/fast-mcp/fast-mcp) - A Ruby gem for Model Context Protocol
- Uses [docker-api](https://github.com/swipely/docker-api) for Docker interactions
- Communication layer provided by [supergateway](https://github.com/supergateway/supergateway)