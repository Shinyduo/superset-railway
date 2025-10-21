FROM apache/superset:latest
USER root

# Where Superset reads its config
ENV SUPERSET_CONFIG_PATH=/app/superset_config.py
ENV FLASK_ENV=production

# Install Postgres driver **inside Superset's venv** + optional Google libs
RUN /app/.venv/bin/pip install --no-cache-dir psycopg2-binary==2.9.9 \
 && /app/.venv/bin/pip install --no-cache-dir \
      google google-api-core google-api-python-client \
      google-cloud-bigquery google-cloud-storage \
 # sanity check: prove the driver is importable by the same Python Superset uses
 && /app/.venv/bin/python - <<'PY'
import sys
print("PYTHON:", sys.executable)
import psycopg2
print("psycopg2:", psycopg2.__version__)
PY

# Copy config + scripts
COPY superset_config.py /app/superset_config.py
COPY startup.sh /app/startup.sh
COPY bootstrap.sh /app/bootstrap.sh
RUN chmod +x /app/startup.sh /app/bootstrap.sh

EXPOSE 8088
CMD ["/bin/bash", "-lc", "/app/startup.sh"]
