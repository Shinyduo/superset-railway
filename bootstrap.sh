#!/usr/bin/env bash
set -euo pipefail

: "${SUPERSET_ADMIN_USER:=admin}"
: "${SUPERSET_ADMIN_PASSWORD:=admin123}"
: "${SUPERSET_ADMIN_EMAIL:=admin@example.com}"
: "${SUPERSET_ADMIN_FIRST_NAME:=Admin}"
: "${SUPERSET_ADMIN_LAST_NAME:=User}"

echo "⏳ Running DB migrations..."
superset db upgrade

# Create admin user if it doesn't exist (ignore error if it does)
echo "👤 Ensuring admin user exists: ${SUPERSET_ADMIN_USER}"
superset fab create-admin \
  --username "${SUPERSET_ADMIN_USER}" \
  --firstname "${SUPERSET_ADMIN_FIRST_NAME}" \
  --lastname "${SUPERSET_ADMIN_LAST_NAME}" \
  --email "${SUPERSET_ADMIN_EMAIL}" \
  --password "${SUPERSET_ADMIN_PASSWORD}" || true

echo "🧰 Initializing default roles, permissions, and examples setting..."
superset init

echo "✅ Bootstrap completed."
