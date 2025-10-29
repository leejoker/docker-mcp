# Docker-MCP

Docker-MCP 是一个基于 Ruby 的服务器，提供用于与 Docker 服务交互的模型上下文协议 (MCP) 工具。它允许外部客户端通过标准的 MCP 接口执行 Docker 操作，如管理镜像、容器和获取 Docker 服务信息。

## 🚀 功能特性

- **Docker 操作**: 远程管理 Docker 镜像和容器
- **服务信息**: 获取 Docker 服务版本和系统信息
- **MCP 标准**: 实现模型上下文协议以进行标准化交互
- **容器支持**: 包含 Dockerfile 和 docker-compose 配置
- **Stdio 接口**: 通过标准输入/输出流进行通信
- **容器创建**: 创建和管理具有可配置端口的容器
- **镜像管理**: 拉取、列出和删除 Docker 镜像
- **容器管理**: 列出、检查和创建 Docker 容器

## 📋 前置要求

- Ruby 3.4+
- Docker API 访问权限 (确保 Docker 守护进程正在运行)
- Node.js (用于 supergateway 依赖)

## 🛠️ 安装

### 本地安装

1. 克隆仓库:
   ```bash
   git clone https://github.com/leejoker/docker-mcp.git
   cd docker-mcp
   ```

2. 安装依赖:
   ```bash
   gem install bundler # 如果尚未安装
   bundle install
   ```

3. 安装 supergateway (用于 HTTP 接口):
   ```bash
   npm install -g supergateway
   ```

4. 直接运行服务器:
   ```bash
   ./bin/docker-mcp
   ```
   
   或使用 supergateway 暴露为 HTTP:
   ```bash
   supergateway --stdio "./bin/docker-mcp" --port 8080 --baseUrl "http://localhost:8080" --ssePath "/sse" --messagePath "/message"
   ```

### 使用 Docker

使用 Docker 构建并运行服务:

```bash
# 构建镜像
docker build -t docker-mcp:1.0.0 .

# 运行容器
docker run -d --name docker-mcp -p 8080:8080 --restart unless-stopped docker-mcp:1.0.0
```

或使用提供的 docker-compose 文件:

```bash
docker-compose up -d
```

## ⚙️ 依赖项

该项目依赖于以下关键组件：

- `docker-api` gem: 提供与 Docker 守护进程通信的 Ruby 接口
- `fast-mcp` gem: 实现模型上下文协议标准
- `supergateway`: 允许 stdio 到 HTTP 通信以进行 MCP 交互
- `timbru31/ruby-node:3.4-slim-iron`: 包含 Ruby 3.4 和 Node.js 的基础 Docker 镜像

## 🛠 可用工具

服务器提供以下 Docker MCP 工具:

### 健康检查
- **PingTool**: 检查服务器健康状态
  - 描述: `ping the server to check it healthy status`
  - 返回: `'pong'`

### Docker 服务信息
- **DockerVersion**: 获取 Docker 服务版本
  - 描述: `show the version of docker service`
  - 返回: Docker 版本信息

- **DockerInfo**: 获取 Docker 服务信息
  - 描述: `show the info of docker service`
  - 返回: Docker 系统信息

### 镜像管理
- **ImageList**: 列出所有 Docker 镜像
  - 描述: `show all docker image info`
  - 返回: 镜像信息的 JSON 数组

- **ImagePull**: 按 URL 拉取 Docker 镜像
  - 描述: `pull an docker image with specified url and then return the image info`
  - 参数: `url` (必填字符串) - Docker 镜像 URL
  - 返回: 拉取后的镜像信息

- **ImageRemove**: 按 URL 删除镜像
  - 描述: `remove an docker image with specified url then return the image info, url format is [repo:tag]`
  - 参数: `url` (必填字符串) - Docker 镜像 URL，格式为 `repo:tag`
  - 返回: 已删除镜像的信息

- **ImageRemoveById**: 按 ID 删除镜像
  - 描述: `remove an docker image by id`
  - 参数: `id` (必填字符串) - Docker 镜像 ID
  - 返回: 已删除镜像的信息

### 容器管理
- **ContainerList**: 列出所有 Docker 容器
  - 描述: `show all docker containers info`
  - 返回: 容器信息的 JSON 数组

- **ContainerInfo**: 获取特定容器的信息
  - 描述: `show container info by container id`
  - 参数: `id` (必填字符串) - 容器 ID
  - 返回: 详细的容器信息

- **ContainerCreate**: 使用镜像和端口配置创建新容器
  - 描述: `create container with image name and tag`
  - 参数:
    - `image` (必填字符串) - 镜像名称
    - `tag` (必填字符串) - 镜像标签
    - `port` (必填字符串) - 要暴露的容器端口
    - `target_port` (必填字符串) - 要绑定到的主机端口
  - 返回: 创建后的容器信息
  - 注意: 容器将以启用 TTY、连接标准输入和自动删除的方式创建

## 🏗️ 架构

项目结构如下:

```
lib/
├── server/
│   └── stdio_server.rb    # 主要的 MCP 服务器实现
└── tools/
    ├── hello.rb          # 健康检查工具
    ├── docker.rb         # Docker 服务信息工具
    ├── image.rb          # 镜像管理工具
    └── container.rb      # 容器管理工具
```

### 核心组件

- **StdioServer**: 注册所有 MCP 工具并启动服务器的主服务器类
- **PingTool**: 简单的健康检查功能
- **DockerTools**: 包含所有 Docker 相关工具的命名空间
- **DockerVersion & DockerInfo**: 服务信息工具
- **镜像工具**: 镜像列表、拉取和删除工具
- **容器工具**: 容器列表、检查和创建工具

## 🧪 使用示例

### 与 MCP 客户端一起使用

服务器运行后，您可以使用 MCP 客户端与之交互。以下是调用示例：

- **PingTool**: 检查服务器状态
  ```json
  {
    "method": "call_tool",
    "params": {
      "name": "ping_tool",
      "arguments": {}
    }
  }
  ```

- **DockerVersion**: 获取 Docker 版本
  ```json
  {
    "method": "call_tool",
    "params": {
      "name": "docker_version",
      "arguments": {}
    }
  }
  ```

- **ImageList**: 列出所有镜像
  ```json
  {
    "method": "call_tool",
    "params": {
      "name": "image_list",
      "arguments": {}
    }
  }
  ```

- **ImagePull**: 拉取指定镜像
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

- **ContainerCreate**: 创建新容器
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

## 🚀 开发

在本地运行服务器进行开发:

1. 安装依赖:
   ```bash
   bundle install
   npm install -g supergateway
   ```

2. 直接运行服务器:
   ```bash
   ./bin/docker-mcp
   ```
   
   或使用 supergateway 暴露为 HTTP:
   ```bash
   supergateway --stdio "./bin/docker-mcp" --port 8080 --baseUrl "http://localhost:8080" --ssePath "/sse" --messagePath "/message"
   ```

这将启动 stdio 服务器，可通过 supergateway 连接以获得 HTTP 访问。

## 🧪 测试

运行项目测试 (如果存在):
```bash
bundle exec rake test
# 或
rspec
```

## 🔐 Docker 访问配置

对于 Docker API 访问，请确保 Docker 守护进程正在运行且可访问。您可能需要以额外权限运行容器：

```bash
# 直接运行 Docker 容器时
docker run -d --name docker-mcp -p 8080:8080 --restart unless-stopped --privileged -v /var/run/docker.sock:/var/run/docker.sock docker-mcp:1.0.0
```

或更新您的 docker-compose.yaml:

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

## 🤝 贡献

1. Fork 仓库
2. 创建功能分支 (`git checkout -b feature/amazing-feature`)
3. 进行更改
4. 如适用，添加测试
5. 提交更改 (`git commit -m 'Add some amazing feature'`)
6. 推送到分支 (`git push origin feature/amazing-feature`)
7. 提交拉取请求

## 📄 许可证

本项目采用 Apache 许可证 2.0 版 - 详情请参见 [LICENSE](LICENSE) 文件。

## 👤 作者

- **leejoker** - [GitHub](https://github.com/leejoker)

## 🙏 致谢

- 使用 [fast-mcp](https://github.com/fast-mcp/fast-mcp) - 用于模型上下文协议的 Ruby gem
- 使用 [docker-api](https://github.com/swipely/docker-api) 进行 Docker 交互
- 通信层由 [supergateway](https://github.com/supergateway/supergateway) 提供