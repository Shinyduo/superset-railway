#!/usr/bin/env bash
set -euo pipefail

SUPERSET_CMD="/usr/bin/superset"
if [ ! -x "$SUPERSET_CMD" ]; then
  SUPERSET_CMD="/app/.venv/bin/superset"
fi

echo "🔧 Superset version:"
$SUPERSET_CMD version || true

echo "🚀 Bootstrapping Superset..."
/app/bootstrap.sh "$SUPERSET_CMD"

echo "🌐 Starting Superset..."
exec $SUPERSET_CMD run -h 0.0.0.0 -p "${SUPERSET_PORT:-8088}"
