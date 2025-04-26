# Production Dockerfile for Node.js Express application
FROM node:18-alpine AS build

# Set working directory
WORKDIR /app

# Install dependencies and cache them
COPY package.json package-lock.json* ./
RUN npm ci --omit=dev

# Copy application source
COPY . .

# Build if necessary (TypeScript, Babel, etc.)
RUN npm run build || echo "No build script found"

# Create production image
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Install global process manager
RUN npm install -g pm2

# Create app directory and non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
RUN mkdir -p /app && chown -R appuser:appgroup /app

# Switch to non-root user
USER appuser

# Copy dependency modules and built application from build stage
COPY --from=build --chown=appuser:appgroup /app/node_modules /app/node_modules
COPY --from=build --chown=appuser:appgroup /app/package.json /app/package.json
COPY --from=build --chown=appuser:appgroup /app/dist* /app/dist/
COPY --from=build --chown=appuser:appgroup /app/src* /app/src/

# Environment variables
ENV NODE_ENV=production
ENV PORT=3000

# Add healthcheck
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD wget -q --spider http://localhost:3000/health || exit 1

# Expose the port the app will run on
EXPOSE 3000

# Start the application with PM2
CMD ["pm2-runtime", "start", "dist/index.js", "--name", "app"]
