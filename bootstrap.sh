#!/usr/bin/env bash
set -euo pipefail

# startup.sh (snippet)
SUPERSET_CMD="/usr/bin/superset"
if [ ! -x "$SUPERSET_CMD" ]; then SUPERSET_CMD="/app/.venv/bin/superset"; fi


: "${SUPERSET_ADMIN_USER:=admin}"
: "${SUPERSET_ADMIN_PASSWORD:=admin123}"
: "${SUPERSET_ADMIN_EMAIL:=admin@example.com}"
: "${SUPERSET_ADMIN_FIRST_NAME:=Admin}"
: "${SUPERSET_ADMIN_LAST_NAME:=User}"

echo "⏳ Running DB migrations..."
$SUPERSET_CMD db upgrade

echo "👤 Ensuring admin user exists..."
$SUPERSET_CMD fab create-admin \
  --username "$SUPERSET_ADMIN_USER" \
  --firstname "$SUPERSET_ADMIN_FIRST_NAME" \
  --lastname "$SUPERSET_ADMIN_LAST_NAME" \
  --email "$SUPERSET_ADMIN_EMAIL" \
  --password "$SUPERSET_ADMIN_PASSWORD" || true

echo "🧰 Initializing default roles and permissions..."
$SUPERSET_CMD init

echo "✅ Bootstrap completed."
