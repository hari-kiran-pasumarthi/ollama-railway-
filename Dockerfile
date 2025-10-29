# syntax=docker/dockerfile:1
FROM ubuntu:24.04

# Set working directory
WORKDIR /app

# Install dependencies
RUN apt-get update && apt-get install -y curl tar ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Install Ollama prebuilt binary
RUN curl -L -o ollama.tgz https://github.com/ollama/ollama/releases/latest/download/ollama-linux-amd64.tgz \
    && tar -xzf ollama.tgz -C /usr/local/bin \
    && rm ollama.tgz

RUN chmod +x /usr/local/bin/ollama

# Expose Ollama default port
EXPOSE 11434

# Start Ollama server
CMD ["ollama", "serve"]
