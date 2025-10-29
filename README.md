# Docker-MCP

Docker-MCP is a Ruby-based server that provides Model Context Protocol (MCP) tools for interacting with Docker services. It allows external clients to perform Docker operations such as managing images, containers, and getting Docker service information through a standardized MCP interface.

阅读此文档的其他语言版本: [中文版](README.zh.md)

## 🚀 Features

- **Docker Operations**: Manage Docker images and containers remotely
- **Service Information**: Get Docker service version and system information
- **MCP Standard**: Implements the Model Context Protocol for standardized interactions
- **Container Ready**: Dockerfile and docker-compose configuration included
- **Stdio Interface**: Communicates via standard input/output streams
- **Container Creation**: Create and manage containers with configurable ports
- **Image Management**: Pull, list, and remove Docker images
- **Container Management**: List, inspect, and create Docker containers

## 📋 Prerequisites

- Ruby 3.4+
- Docker API access (ensure Docker daemon is running)
- Node.js (for supergateway dependency)

## 🛠️ Installation

### Local Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/leejoker/docker-mcp.git
   cd docker-mcp
   ```

2. Install dependencies:
   ```bash
   gem install bundler # if not already installed
   bundle install
   ```

3. Install supergateway (for HTTP interface):
   ```bash
   npm install -g supergateway
   ```

4. Run the server directly:
   ```bash
   ./bin/docker-mcp
   ```
   
   Or use supergateway to expose as HTTP:
   ```bash
   supergateway --stdio "./bin/docker-mcp" --port 8080 --baseUrl "http://localhost:8080" --ssePath "/sse" --messagePath "/message"
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

## ⚙️ Dependencies

This project relies on the following key dependencies:

- `docker-api` gem: Provides Ruby interface to communicate with Docker daemon
- `fast-mcp` gem: Implements the Model Context Protocol standard
- `supergateway`: Allows stdio-to-HTTP communication for MCP interaction
- `timbru31/ruby-node:3.4-slim-iron`: Base Docker image with Ruby 3.4 and Node.js

## 🛠 Available Tools

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

- **ContainerCreate**: Create a new container with image, port, and optional configurations
  - Description: `create container with image name, tag, and optional configurations for volumes, tty, and stdin`
  - Arguments: 
    - `image` (required string) - Image name
    - `tag` (required string) - Image tag
    - `port` (required string) - Container port to expose
    - `target_port` (required string) - Host port to bind to
    - `volumes` (optional string) - Volume mappings in format as string separated by commas (e.g., "/host/path1:/container/path1,/host/path2:/container/path2")
    - `tty` (optional bool) - Allocate a pseudo-TTY (default: true)
    - `open_stdin` (optional bool) - Keep STDIN open even if not attached (default: true)
  - Returns: Container information after creation
  - Notes: The container is created with auto-removal enabled and configurable TTY/stdin options and volume mappings

## 🏗️ Architecture

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

### Core Components

- **StdioServer**: The main server class that registers all MCP tools and starts the server
- **PingTool**: Simple health check functionality
- **DockerTools**: Namespace containing all Docker-related tools
- **DockerVersion & DockerInfo**: Service information tools
- **Image Tools**: Image listing, pulling, and removal tools
- **Container Tools**: Container listing, inspection, and creation tools

## 🧪 Usage Examples

### Using with an MCP client

Once the server is running, you can interact with it using an MCP client. Here are example calls:

- **PingTool**: Check server status
  ```json
  {
    "method": "call_tool",
    "params": {
      "name": "ping_tool",
      "arguments": {}
    }
  }
  ```

- **DockerVersion**: Get Docker version
  ```json
  {
    "method": "call_tool",
    "params": {
      "name": "docker_version",
      "arguments": {}
    }
  }
  ```

- **ImageList**: List all images
  ```json
  {
    "method": "call_tool",
    "params": {
      "name": "image_list",
      "arguments": {}
    }
  }
  ```

- **ImagePull**: Pull a specific image
  ```json
  {
    "method": "call_tool",
    "params": {
      "name": "image_pull",
      "arguments": {
        "url": "nginx:latest"
      }
    }
  }
  ```

- **ContainerCreate**: Create a new container
  ```json
  {
    "method": "call_tool",
    "params": {
      "name": "container_create",
      "arguments": {
        "image": "nginx",
        "tag": "latest",
        "port": "80",
        "target_port": "8080"
      }
    }
  }
  ```

- **ContainerCreate with volume mapping and custom options**:
  ```json
  {
    "method": "call_tool",
    "params": {
      "name": "container_create",
      "arguments": {
        "image": "nginx",
        "tag": "latest",
        "port": "80",
        "target_port": "8080",
        "volumes": "/host/data:/usr/share/nginx/html",
        "tty": true,
        "open_stdin": true
      }
    }
  }
  ```

## 🚀 Development

To run the server locally for development:

1. Install dependencies:
   ```bash
   bundle install
   npm install -g supergateway
   ```

2. Run the server directly:
   ```bash
   ./bin/docker-mcp
   ```
   
   Or use supergateway to expose as HTTP:
   ```bash
   supergateway --stdio "./bin/docker-mcp" --port 8080 --baseUrl "http://localhost:8080" --ssePath "/sse" --messagePath "/message"
   ```

This will start the stdio server which can be connected to via supergateway for HTTP access.

## 🧪 Testing

To run the project tests (if any exist):
```bash
bundle exec rake test
# or
rspec
```

## 🔐 Docker Access Configuration

For Docker API access, ensure the Docker daemon is running and accessible. You may need to run the container with additional privileges:

```bash
# When running Docker container directly
docker run -d --name docker-mcp -p 8080:8080 --restart unless-stopped --privileged -v /var/run/docker.sock:/var/run/docker.sock docker-mcp:1.0.0
```

Or update your docker-compose.yaml:

```yaml
version: '3'

services:
  docker-mcp:
    image: docker-mcp:1.0.0
    container_name: docker-mcp
    ports:
      - "8080:8080"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    restart: unless-stopped
    privileged: true
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Add tests if applicable
5. Commit your changes (`git commit -m 'Add some amazing feature'`)
6. Push to the branch (`git push origin feature/amazing-feature`)
7. Open a pull request

## 📄 License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

## 👤 Author

- **leejoker** - [GitHub](https://github.com/leejoker)

## 🙏 Acknowledgments

- Built with [fast-mcp](https://github.com/fast-mcp/fast-mcp) - A Ruby gem for Model Context Protocol
- Uses [docker-api](https://github.com/swipely/docker-api) for Docker interactions
- Communication layer provided by [supergateway](https://github.com/supergateway/supergateway)