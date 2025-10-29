# syntax=docker/dockerfile:1
FROM python:3.10-slim

WORKDIR /app

# Copy all project files
COPY . .

# Install required system packages
RUN apt-get update && apt-get install -y curl git build-essential cmake

# ---- Install Python dependencies manually ----
RUN pip install --no-cache-dir \
    fastapi \
    uvicorn \
    requests \
    tensorflow==2.15.0 \
    tf-keras \
    deepface \
    retinaface \
    pydantic \
    python-multipart

# ---- Build Ollama from source ----
WORKDIR /app/ollama

# Install Go (required by Ollama)
RUN curl -fsSL https://go.dev/dl/go1.22.4.linux-amd64.tar.gz | tar -C /usr/local -xzf -
ENV PATH="/usr/local/go/bin:${PATH}"

# Build Ollama binary
RUN go mod download && go build -o /usr/local/bin/ollama .

# ---- Return to main app ----
WORKDIR /app

# Expose ports for FastAPI and Ollama
EXPOSE 8080 11434

# Start both servers
CMD bash -c "ollama serve & uvicorn backend.main:app --host 0.0.0.0 --port 8080"
