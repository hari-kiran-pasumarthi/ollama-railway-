# syntax=docker/dockerfile:1

# ---- Base Python Environment ----
FROM python:3.10-slim

WORKDIR /app

# Copy your project
COPY . .

# Install system dependencies
RUN apt-get update && apt-get install -y curl git build-essential cmake

# Install Python dependencies
RUN pip install --no-cache-dir -r backend/requirements.txt

# ---- Build Ollama from source ----
WORKDIR /app/ollama

# Install Go (required by Ollama)
RUN curl -fsSL https://go.dev/dl/go1.22.4.linux-amd64.tar.gz | tar -C /usr/local -xzf -
ENV PATH="/usr/local/go/bin:${PATH}"

# Build Ollama binary
RUN go mod download && go build -o /usr/local/bin/ollama .

# ---- Back to app root ----
WORKDIR /app

# Expose ports
EXPOSE 8080 11434

# ---- Run both Ollama and FastAPI ----
CMD bash -c "ollama serve & uvicorn backend.main:app --host 0.0.0.0 --port 8080"
