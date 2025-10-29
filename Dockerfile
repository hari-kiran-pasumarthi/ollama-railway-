# syntax=docker/dockerfile:1
FROM python:3.10-slim

WORKDIR /app
COPY . .

# Install system dependencies
RUN apt-get update && apt-get install -y curl git build-essential cmake

# Install Python dependencies (note: no backend/ prefix)
RUN pip install --no-cache-dir -r requirements.txt

# ---- Build Ollama from source ----
WORKDIR /app/ollama

# Install Go (required by Ollama)
RUN curl -fsSL https://go.dev/dl/go1.22.4.linux-amd64.tar.gz | tar -C /usr/local -xzf -
ENV PATH="/usr/local/go/bin:${PATH}"

# Build Ollama binary
RUN go mod download && go build -o /usr/local/bin/ollama .

# ---- Back to app root ----
WORKDIR /app

EXPOSE 8080 11434

# Start both Ollama and FastAPI
CMD bash -c "ollama serve & uvicorn backend.main:app --host 0.0.0.0 --port 8080"
