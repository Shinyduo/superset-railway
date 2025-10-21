#!/usr/bin/env bash
set -euo pipefail

# Defaults (Railway will inject DATABASE_URL / REDIS_URL if services attached)
: "${SUPERSET_PORT:=8088}"

echo "🔧 Superset version:"
superset version || true

# One-time bootstrap (idempotent; safe to re-run)
echo "🚀 Bootstrapping Superset..."
/app/bootstrap.sh

echo "🌐 Starting Superset on 0.0.0.0:${SUPERSET_PORT}"
exec superset run -h 0.0.0.0 -p "${SUPERSET_PORT}"
