# Multi-stage build for Spring Boot applications (Production)
# Stage 1: Build the application
FROM maven:3.9-eclipse-temurin-17 AS builder

# Set working directory
WORKDIR /build

# Copy pom.xml for dependency resolution
COPY pom.xml .
COPY src ./src

# Build and package the application
# Skip tests in the build stage if needed with -DskipTests
RUN mvn clean package -DskipTests

# Stage 2: Setup the runtime
FROM eclipse-temurin:17-jre-alpine

# Add labels
LABEL maintainer="Your Organization <dev@yourorg.com>"
LABEL app="spring-boot-app"
LABEL version="1.0"

# Create a non-root user to run the app
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Set working directory
WORKDIR /app

# Copy the jar file from the build stage
COPY --from=builder /build/target/*.jar app.jar

# Change ownership to the non-root user
RUN chown -R appuser:appgroup /app

# Switch to the non-root user
USER appuser

# Environment variables
ENV JAVA_OPTS="-XX:+UseContainerSupport -XX:MaxRAMPercentage=75.0"
ENV SPRING_PROFILES_ACTIVE="production"

# Expose port
EXPOSE 8080

# Add healthcheck
HEALTHCHECK --interval=30s --timeout=5s --start-period=60s --retries=3 \
  CMD wget -q --spider http://localhost:8080/actuator/health || exit 1

# Run the application
ENTRYPOINT ["sh", "-c", "java ${JAVA_OPTS} -jar app.jar"]
