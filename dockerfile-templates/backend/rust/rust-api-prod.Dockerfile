# Multi-stage build for Rust API (Production)
FROM rust:1.72-slim-bookworm as builder

# Install build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    pkg-config \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Create a new empty shell project
WORKDIR /usr/src/app
COPY Cargo.toml Cargo.lock ./

# Build only the dependencies to cache them
RUN mkdir -p src && \
    echo "fn main() {}" > src/main.rs && \
    cargo build --release && \
    rm -rf src

# Copy the actual source code
COPY . .

# Build for release
RUN cargo build --release

# Final stage: Runtime
FROM debian:bookworm-slim

# Install runtime dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user
RUN groupadd -r appuser && useradd -r -g appuser appuser

# Create app directory
WORKDIR /app

# Copy the build artifact from the builder stage
COPY --from=builder /usr/src/app/target/release/my-rust-app /app/my-rust-app

# Copy configuration files if needed
COPY --from=builder /usr/src/app/config /app/config

# Set ownership
RUN chown -R appuser:appuser /app

# Switch to non-root user
USER appuser

# Environment variables
ENV RUST_LOG=info
ENV ROCKET_ENV=production
ENV ROCKET_PORT=8000
ENV ROCKET_ADDRESS=0.0.0.0

# Expose port
EXPOSE 8000

# Add healthcheck
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD wget -q --spider http://localhost:8000/health || exit 1

# Run the binary
CMD ["/app/my-rust-app"]
