FROM apache/superset:latest

USER root

# Keep Python path from base; point Superset at our config
ENV SUPERSET_CONFIG_PATH=/app/docker/superset_config.py
ENV FLASK_ENV=production

# Optional Google extras (remove if not needed)
RUN pip install --no-cache-dir google google-api-core google-api-python-client \
    google-cloud-bigquery google-cloud-storage

# Add our scripts + config
COPY startup.sh /app/startup.sh
COPY bootstrap.sh /app/bootstrap.sh
COPY superset_config.py /app/docker/superset_config.py

# Make scripts executable
RUN chmod +x /app/startup.sh /app/bootstrap.sh

EXPOSE 8088

# Start web server via our startup script (handles init + run)
CMD ["/bin/bash", "-lc", "/app/startup.sh"]
