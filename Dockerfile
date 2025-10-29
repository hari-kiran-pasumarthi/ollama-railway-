# syntax=docker/dockerfile:1
FROM debian:bookworm-slim

WORKDIR /app

# Install required tools
RUN apt-get update && apt-get install -y curl tar ca-certificates && rm -rf /var/lib/apt/lists/*

# Download & install Ollama (handles any internal filename automatically)
RUN curl -L -o ollama.tgz https://github.com/ollama/ollama/releases/latest/download/ollama-linux-amd64.tgz \
    && tar -xzf ollama.tgz \
    && mv $(find . -type f -name "ollama*" -perm +111 | head -n 1) /usr/local/bin/ollama \
    && chmod +x /usr/local/bin/ollama \
    && rm -rf ollama.tgz

# Expose Ollama default port
EXPOSE 11434

# Start Ollama server
CMD ["ollama", "serve"]
