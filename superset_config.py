import os
import logging
logger = logging.getLogger(__name__)

_raw = os.environ.get("DATABASE_URL") or os.environ.get("SQLALCHEMY_DATABASE_URI") or ""
uri = _raw
if uri.startswith("postgres://"):
    uri = "postgresql+psycopg2://" + uri[len("postgres://"):]
elif uri.startswith("postgresql://") and "+psycopg2" not in uri:
    uri = "postgresql+psycopg2://" + uri[len("postgresql://"):]
SQLALCHEMY_DATABASE_URI = uri

SECRET_KEY = os.environ.get("SUPERSET_SECRET_KEY", "CHANGE_ME_SUPERSET_SECRET")
SUPERSET_ENV = os.environ.get("SUPERSET_ENV", "production")
SUPERSET_LOAD_EXAMPLES = os.environ.get("SUPERSET_LOAD_EXAMPLES", "no")
SUPERSET_PORT = int(os.environ.get("SUPERSET_PORT", "8088"))

REDIS_URL = os.environ.get("REDIS_URL")
CACHE_CONFIG = {
    "CACHE_TYPE": "RedisCache",
    "CACHE_DEFAULT_TIMEOUT": 300,
    "CACHE_KEY_PREFIX": "superset_",
    "CACHE_REDIS_URL": REDIS_URL,
}
DATA_CACHE_CONFIG = CACHE_CONFIG

RESULTS_BACKEND = None
if REDIS_URL:
    try:
        from cachelib.redis import RedisCache
        RESULTS_BACKEND = RedisCache(host=None, port=None, password=None, db=1, url=REDIS_URL)
    except Exception:
        RESULTS_BACKEND = None

class CeleryConfig:
    broker_url = f"{REDIS_URL}/1" if REDIS_URL else None
    result_backend = f"{REDIS_URL}/1" if REDIS_URL else None
    imports = ("superset.sql_lab",)
    task_annotations = {"sql_lab.get_sql_results": {"rate_limit": "10/s"}}

CELERY_CONFIG = CeleryConfig

FEATURE_FLAGS = {"DASHBOARD_NATIVE_FILTERS": True, "DASHBOARD_CROSS_FILTERS": True}
ENABLE_CORS = True
CORS_OPTIONS = {"supports_credentials": True, "allow_headers": ["*"], "resources": ["*"]}
LOG_LEVEL = "INFO"
