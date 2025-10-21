# Use the official Apache Superset image as a base
FROM apache/superset:latest
USER root

# Environment
ENV SUPERSET_CONFIG_PATH=/app/superset_config.py
ENV FLASK_ENV=production

# Install Postgres driver + optional Google connectors
RUN pip install --no-cache-dir psycopg2-binary \
    google google-api-core google-api-python-client \
    google-cloud-bigquery google-cloud-storage

# Copy configuration and helper scripts
COPY superset_config.py /app/superset_config.py
COPY startup.sh /app/startup.sh
COPY bootstrap.sh /app/bootstrap.sh
RUN chmod +x /app/startup.sh /app/bootstrap.sh

EXPOSE 8088
CMD ["/bin/bash", "-lc", "/app/startup.sh"]
