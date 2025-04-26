# Multi-stage build for Go API (Production)
FROM golang:1.21-alpine AS builder

# Install build dependencies
RUN apk add --no-cache git build-base

# Set working directory
WORKDIR /app

# Copy go.mod and go.sum first to leverage Docker cache
COPY go.mod go.sum ./
RUN go mod download

# Copy source code
COPY . .

# Build the Go application with optimizations
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build \
    -ldflags="-w -s -X main.version=$(git describe --tags --always) -X main.buildTime=$(date +%Y-%m-%dT%H:%M:%S)" \
    -o /app/server ./cmd/api

# Scan for vulnerabilities (optional)
RUN go install golang.org/x/vuln/cmd/govulncheck@latest && \
    govulncheck ./...

# Second stage: Production image
FROM alpine:3.18

# Add CA certificates
RUN apk add --no-cache ca-certificates tzdata && update-ca-certificates

# Create non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Set working directory
WORKDIR /app

# Copy executable from builder stage
COPY --from=builder /app/server .

# Copy necessary assets and configurations
COPY --from=builder /app/configs ./configs
COPY --from=builder /app/migrations ./migrations
COPY --from=builder /app/static ./static

# Set ownership
RUN chown -R appuser:appgroup /app

# Switch to non-root user
USER appuser

# Environment variables
ENV GIN_MODE=release
ENV PORT=8080

# Expose port
EXPOSE 8080

# Add healthcheck
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD wget -q --spider http://localhost:8080/health || exit 1

# Run the executable
CMD ["/app/server"]
