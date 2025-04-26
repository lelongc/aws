# Multi-stage build for React application (Production)
# Stage 1: Build the React application
FROM node:18-alpine AS build

# Set working directory
WORKDIR /app

# Install dependencies and cache them
COPY package.json package-lock.json* ./
RUN npm ci

# Copy source files
COPY . .

# Build the application
RUN npm run build

# Stage 2: Serve the built application using Nginx
FROM nginx:1.25-alpine

# Copy built assets from the build stage
COPY --from=build /app/build /usr/share/nginx/html

# Copy custom nginx config if needed
COPY nginx/nginx.conf /etc/nginx/conf.d/default.conf

# Add healthcheck
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD wget -q --spider http://localhost/ || exit 1

# Expose port 80
EXPOSE 80

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]
