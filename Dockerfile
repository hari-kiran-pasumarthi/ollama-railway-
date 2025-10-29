# syntax=docker/dockerfile:1
FROM debian:bookworm-slim

WORKDIR /app

# Install curl, tar, and SSL certificates
RUN apt-get update && apt-get install -y curl tar ca-certificates && rm -rf /var/lib/apt/lists/*

# Download and install Ollama binary
RUN curl -L -o ollama.tgz https://github.com/ollama/ollama/releases/latest/download/ollama-linux-amd64.tgz \
    && tar -xzf ollama.tgz \
    && mv ollama /usr/local/bin/ollama \
    && chmod +x /usr/local/bin/ollama \
    && rm ollama.tgz

# Expose Ollama’s default port
EXPOSE 11434

# ✅ Define the start command so Railway knows what to run
CMD ["ollama", "serve"]
