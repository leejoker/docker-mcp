# Docker-MCP

Docker-MCP 是一个基于 Ruby 的服务器，提供用于与 Docker 服务交互的模型上下文协议 (MCP) 工具。它允许外部客户端通过标准的 MCP 接口执行 Docker 操作，如管理镜像、容器和获取 Docker 服务信息。

## 功能特性

- **Docker 操作**: 远程管理 Docker 镜像和容器
- **服务信息**: 获取 Docker 服务版本和系统信息
- **MCP 标准**: 实现模型上下文协议以进行标准化交互
- **容器支持**: 包含 Dockerfile 和 docker-compose 配置
- **Stdio 接口**: 通过标准输入/输出流进行通信

## 前置要求

- Ruby 3.4+ (使用 `timbru31/ruby-node:3.4-slim-iron` Docker 基础镜像)
- Docker API 访问权限
- Node.js (用于 supergateway 依赖)

## 安装

### 本地安装

1. 克隆仓库:
   ```bash
   git clone https://github.com/leejoker/docker-mcp.git
   cd docker-mcp
   ```

2. 安装依赖:
   ```bash
   gem install docker-mcp
   # 或者
   bundle install
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

## 配置

服务默认运行在 8080 端口，并通过 supergateway 暴露以下端点:
- 基础 URL: `http://localhost:8080`
- SSE 路径: `/sse`
- 消息路径: `/message`

## 可用工具

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

## 架构

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

服务器使用:
- `fast-mcp` gem 实现 MCP 协议
- `docker-api` gem 进行 Docker 交互
- `supergateway` 进行 stdio 到 HTTP 的通信

## 开发

在本地运行服务器进行开发:

1. 安装依赖:
   ```bash
   bundle install
   npm install -g supergateway
   ```

2. 运行服务器:
   ```bash
   ./bin/docker-mcp
   ```

这将启动 stdio 服务器，可通过 supergateway 连接以获得 HTTP 访问。

## 贡献

1. Fork 仓库
2. 创建功能分支
3. 进行更改
4. 如适用，添加测试
5. 提交拉取请求

## 许可证

本项目采用 MIT 许可证 - 详情请参见 [LICENSE](LICENSE) 文件。

## 作者

- **leejoker** - [GitHub](https://github.com/leejoker)

## 致谢

- 使用 [fast-mcp](https://github.com/fast-mcp/fast-mcp) - 用于模型上下文协议的 Ruby gem
- 使用 [docker-api](https://github.com/swipely/docker-api) 进行 Docker 交互
- 通信层由 [supergateway](https://github.com/supergateway/supergateway) 提供