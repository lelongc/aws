# Multi-stage build for NestJS applications (Production)
FROM node:18-alpine AS builder

# Set working directory
WORKDIR /app

# Install dependencies
COPY package.json yarn.lock* package-lock.json* ./
RUN \
    if [ -f yarn.lock ]; then yarn --frozen-lockfile; \
    else npm ci; \
    fi

# Copy source code
COPY . .

# Build application
RUN \
    if [ -f yarn.lock ]; then yarn build; \
    else npm run build; \
    fi

# Production stage
FROM node:18-alpine AS production

# Set working directory
WORKDIR /app

# Create non-root user
RUN addgroup --system --gid 1001 nodejs && \
    adduser --system --uid 1001 nestjs && \
    chown -R nestjs:nodejs /app

# Set environment variables
ENV NODE_ENV production

# Copy built application and necessary files
COPY --from=builder --chown=nestjs:nodejs /app/dist ./dist
COPY --from=builder --chown=nestjs:nodejs /app/node_modules ./node_modules
COPY --from=builder --chown=nestjs:nodejs /app/package.json ./package.json

# Copy configuration files if needed
COPY --chown=nestjs:nodejs config ./config

# Switch to non-root user
USER nestjs

# Expose application port
EXPOSE 3000

# Add healthcheck
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD wget -q --spider http://localhost:3000/health || exit 1

# Start the NestJS application
CMD ["node", "dist/main"]
