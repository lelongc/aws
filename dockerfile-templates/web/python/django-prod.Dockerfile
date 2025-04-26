# Multi-stage build for Django application (Production)
FROM python:3.11-slim-bookworm as builder

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Install Python dependencies
COPY requirements.txt .
RUN pip wheel --no-cache-dir --wheel-dir /app/wheels -r requirements.txt

# Stage 2: Runtime
FROM python:3.11-slim-bookworm

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    libpq5 \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user
RUN addgroup --system appgroup && adduser --system --group appuser

# Create directories and set permissions
RUN mkdir -p /app/media /app/static && \
    chown -R appuser:appgroup /app

# Set working directory
WORKDIR /app

# Copy wheels from builder stage
COPY --from=builder /app/wheels /wheels
RUN pip install --no-cache-dir /wheels/*

# Copy project files
COPY --chown=appuser:appgroup . .

# Collect static files
RUN SECRET_KEY=dummy_key_for_collect_static \
    DJANGO_SETTINGS_MODULE=myproject.settings.production \
    python manage.py collectstatic --no-input

# Set environment variables
ENV DJANGO_SETTINGS_MODULE=myproject.settings.production
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1
ENV GUNICORN_WORKERS=4
ENV GUNICORN_THREADS=2

# Switch to non-root user
USER appuser

# Expose port
EXPOSE 8000

# Add healthcheck
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD curl --fail http://localhost:8000/health/ || exit 1

# Run gunicorn
CMD gunicorn myproject.wsgi:application \
    --workers $GUNICORN_WORKERS \
    --threads $GUNICORN_THREADS \
    --bind 0.0.0.0:8000 \
    --access-logfile - \
    --error-logfile -
