# 开发说明

## submodule

```shell
# 拉取submodule
git submodule update --init --recursive
```

## 生成grpc文件

```shell

# 安装grpc_tools

gem install grpc-tools

# 生成ruby代码

grpc_tools_ruby_protoc --ruby_out=. --grpc_out=. -I proto/vendor -I proto/vendor/github.com/gogo/protobuf -I proto/vendor/github.com/googleapis/googleapis proto/vendor/github.com/containerd/containerd/api/types/descriptor.proto

grpc_tools_ruby_protoc --ruby_out=. --grpc_out=. -I proto/vendor -I proto/vendor/github.com/gogo/protobuf -I proto/vendor/github.com/googleapis/googleapis proto/vendor/github.com/containerd/containerd/api/types/platform.proto

grpc_tools_ruby_protoc --ruby_out=. --grpc_out=. -I proto/vendor -I proto/vendor/github.com/gogo/protobuf -I proto/vendor/github.com/googleapis/googleapis proto/vendor/github.com/containerd/containerd/api/types/transfer/imagestore.proto

grpc_tools_ruby_protoc --ruby_out=. --grpc_out=. -I proto/vendor -I proto/vendor/github.com/gogo/protobuf -I proto/vendor/github.com/googleapis/googleapis proto/vendor/github.com/containerd/containerd/api/types/transfer/registry.proto

grpc_tools_ruby_protoc --ruby_out=lib --grpc_out=lib -I proto/vendor -I proto/vendor/github.com/gogo/protobuf -I proto/vendor/github.com/googleapis/googleapis proto/vendor/github.com/containerd/containerd/api/services/transfer/v1/transfer.proto

grpc_tools_ruby_protoc --ruby_out=. --grpc_out=. -I proto/vendor -I proto/vendor/github.com/gogo/protobuf -I proto/vendor/github.com/googleapis/googleapis proto/vendor/github.com/containerd/containerd/api/services/containers/v1/containers.proto

grpc_tools_ruby_protoc --ruby_out=. --grpc_out=. -I proto/vendor -I proto/vendor/github.com/gogo/protobuf -I proto/vendor/github.com/googleapis/googleapis proto/vendor/github.com/containerd/containerd/api/services/images/v1/images.proto

grpc_tools_ruby_protoc --ruby_out=. --grpc_out=. -I proto/vendor -I proto/vendor/github.com/gogo/protobuf -I proto/vendor/github.com/googleapis/googleapis proto/vendor/github.com/containerd/containerd/api/services/namespaces/v1/namespace.proto

grpc_tools_ruby_protoc --ruby_out=. --grpc_out=. -I proto/vendor -I proto/vendor/github.com/gogo/protobuf -I proto/vendor/github.com/googleapis/googleapis proto/vendor/github.com/containerd/containerd/api/services/version/v1/version.proto

```