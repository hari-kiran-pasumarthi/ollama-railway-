# syntax=docker/dockerfile:1
FROM debian:bookworm-slim

WORKDIR /app

# Install dependencies
RUN apt-get update && apt-get install -y curl tar ca-certificates && rm -rf /var/lib/apt/lists/*

# Download and install Ollama binary from GitHub releases
RUN curl -L -o ollama.tgz https://github.com/ollama/ollama/releases/latest/download/ollama-linux-amd64.tgz \
    && tar -xzf ollama.tgz \
    && mv ollama-linux-amd64/bin/ollama /usr/local/bin/ollama \
    && chmod +x /usr/local/bin/ollama \
    && rm -rf ollama.tgz ollama-linux-amd64

# Expose Ollama default port
EXPOSE 11434

# Start Ollama server
CMD ["ollama", "serve"]
