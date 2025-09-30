FROM timbru31/ruby-node:3.4-slim-iron

WORKDIR /app

COPY Gemfile* ./
RUN apt update \
    && apt install -y build-essential ruby-dev \
    && bundle install \
    && rm -rf /var/lib/apt/lists/* \
    && npm install -g supergateway

COPY . .

EXPOSE 8080

ENTRYPOINT ["supergateway", "--stdio", "/app/bin/docker-mcp", "--port", "8080", "--baseUrl", "http://localhost:8080", "--ssePath", "/sse", "--messagePath", "/message"]
