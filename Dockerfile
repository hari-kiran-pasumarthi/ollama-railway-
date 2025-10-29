# syntax=docker/dockerfile:1
FROM debian:bookworm-slim

WORKDIR /app

# Install dependencies
RUN apt-get update && apt-get install -y curl tar ca-certificates findutils && rm -rf /var/lib/apt/lists/*

# Download and install Ollama binary safely
RUN curl -L -o ollama.tgz https://github.com/ollama/ollama/releases/latest/download/ollama-linux-amd64.tgz \
    && tar -xzf ollama.tgz \
    && mv $(find . -type f -name "ollama*" -perm /111 | head -n 1) /usr/local/bin/ollama \
    && chmod +x /usr/local/bin/ollama \
    && rm -rf ollama.tgz

# Expose Ollama port
EXPOSE 11434

# Start Ollama
CMD ["ollama", "serve", "--host", "0.0.0.0"]

