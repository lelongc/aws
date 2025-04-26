# All-in-one Prometheus and Grafana monitoring container
FROM prom/prometheus:v2.45.0 as prometheus

FROM grafana/grafana:10.0.3 as grafana

# Final image
FROM ubuntu:22.04

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install required packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    tzdata \
    nginx \
    supervisor \
    && rm -rf /var/lib/apt/lists/*

# Create directories
RUN mkdir -p /etc/prometheus /var/lib/prometheus /etc/grafana /var/lib/grafana /etc/supervisor/conf.d

# Copy Prometheus binaries and configuration
COPY --from=prometheus /bin/prometheus /bin/prometheus
COPY --from=prometheus /bin/promtool /bin/promtool
COPY --from=prometheus /etc/prometheus/prometheus.yml /etc/prometheus/prometheus.yml
COPY prometheus/*.yml /etc/prometheus/

# Copy Grafana binaries and configuration
COPY --from=grafana /usr/share/grafana /usr/share/grafana
COPY --from=grafana /etc/grafana /etc/grafana
COPY grafana/datasources /etc/grafana/provisioning/datasources
COPY grafana/dashboards /etc/grafana/provisioning/dashboards
COPY grafana/dashboard-definitions /var/lib/grafana/dashboards

# Configure Nginx as a reverse proxy
COPY nginx/nginx.conf /etc/nginx/nginx.conf

# Configure supervisord
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Set permissions
RUN mkdir -p /var/log/supervisor /var/log/nginx /var/log/prometheus /var/log/grafana && \
    chown -R nobody:nogroup /etc/prometheus /var/lib/prometheus /var/log/prometheus && \
    chown -R nobody:nogroup /usr/share/grafana /etc/grafana /var/lib/grafana /var/log/grafana

# Expose ports
EXPOSE 80 9090 3000

# Set healthcheck
HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
  CMD curl -f http://localhost:80/health || exit 1

# Start supervisor as the container entrypoint
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
