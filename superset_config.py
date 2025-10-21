import os
import logging

logger = logging.getLogger(__name__)

# -----------------------------------------------------------------------------
# Core
# -----------------------------------------------------------------------------
# Prefer DATABASE_URL if present (Railway), otherwise SQLALCHEMY_DATABASE_URI
SQLALCHEMY_DATABASE_URI = (
    os.environ.get("DATABASE_URL")
    or os.environ.get("SQLALCHEMY_DATABASE_URI")
)

# Superset expects SECRET_KEY; also accept SUPERSET_SECRET_KEY for convenience
SECRET_KEY = os.environ.get("SECRET_KEY") or os.environ.get(
    "SUPERSET_SECRET_KEY", "CHANGE_ME_SUPERSET_SECRET"
)

# Basic env flags
SUPERSET_ENV = os.environ.get("SUPERSET_ENV", "production")
SUPERSET_LOAD_EXAMPLES = os.environ.get("SUPERSET_LOAD_EXAMPLES", "no")
SUPERSET_PORT = int(os.environ.get("SUPERSET_PORT", "8088"))

# -----------------------------------------------------------------------------
# Caching (Redis)
# -----------------------------------------------------------------------------
REDIS_URL = os.environ.get("REDIS_URL")  # Railway injects when Redis service attached

CACHE_CONFIG = {
    "CACHE_TYPE": "RedisCache",
    "CACHE_DEFAULT_TIMEOUT": 300,
    "CACHE_KEY_PREFIX": "superset_",
    "CACHE_REDIS_URL": REDIS_URL,
}
DATA_CACHE_CONFIG = CACHE_CONFIG

# Optional: Query results backend (speeds up dashboards with heavy queries)
RESULTS_BACKEND = None
if REDIS_URL:
    try:
        from cachelib.redis import RedisCache  # noqa
        RESULTS_BACKEND = RedisCache(host=None, port=None, password=None, db=1, url=REDIS_URL)
    except Exception:  # pragma: no cover
        RESULTS_BACKEND = None

# -----------------------------------------------------------------------------
# Celery (optional; only if you plan on async SQL or reports)
# -----------------------------------------------------------------------------
class CeleryConfig:
    broker_url = f"{REDIS_URL}/1" if REDIS_URL else None
    result_backend = f"{REDIS_URL}/1" if REDIS_URL else None
    imports = ("superset.sql_lab",)
    task_annotations = {"sql_lab.get_sql_results": {"rate_limit": "10/s"}}

CELERY_CONFIG = CeleryConfig

# -----------------------------------------------------------------------------
# Security / CORS / Feature flags
# -----------------------------------------------------------------------------
FEATURE_FLAGS = {
    "DASHBOARD_NATIVE_FILTERS": True,
    "DASHBOARD_CROSS_FILTERS": True,
}

ENABLE_CORS = True
CORS_OPTIONS = {
    "supports_credentials": True,
    "allow_headers": ["*"],
    "resources": ["*"],
}

LOG_LEVEL = "INFO"
