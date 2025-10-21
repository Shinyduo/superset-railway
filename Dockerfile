# Use the official Apache Superset image as a base
FROM apache/superset:latest

USER root

# -----------------------------------------------------------------------------
# Environment setup
# -----------------------------------------------------------------------------
# Tell Superset where to find our custom config
ENV SUPERSET_CONFIG_PATH=/app/superset_config.py
ENV FLASK_ENV=production

# -----------------------------------------------------------------------------
# (Optional) Install Google Cloud connectors and APIs
# -----------------------------------------------------------------------------
RUN pip install --no-cache-dir \
    google \
    google-api-core \
    google-api-python-client \
    google-cloud-bigquery \
    google-cloud-storage

# -----------------------------------------------------------------------------
# Copy configuration and helper scripts
# -----------------------------------------------------------------------------
COPY superset_config.py /app/superset_config.py
COPY startup.sh /app/startup.sh
COPY bootstrap.sh /app/bootstrap.sh

# Make startup and bootstrap scripts executable
RUN chmod +x /app/startup.sh /app/bootstrap.sh

# -----------------------------------------------------------------------------
# Networking
# -----------------------------------------------------------------------------
EXPOSE 8088

# -----------------------------------------------------------------------------
# Launch sequence
# -----------------------------------------------------------------------------
CMD ["/bin/bash", "-lc", "/app/startup.sh"]
