import json

from os import environ, path


this_dir = path.abspath(path.dirname(__file__))

name = 'Stack Setup'
database = f'sqlite:///{path.join(this_dir, "database.db")}'

template_folder = path.join(this_dir, 'template')
static_folder = path.join(this_dir, 'static')

auth_backend = 'miniwiki.auth.SimpleAuthBackend'

with open(path.join(this_dir, 'users.json'), 'r') as f:
    users = json.load(f)

auth_backend_settings = {
    'users': users,
}

cache_backend = 'miniwiki.cache.PymemcacheCacheBackend'
cache_backend_settings = {
    'host': 'localhost',
    'port': 11211,
}


# Env settings
#

is_production = environ.get('ENV', 'development') == 'production'

debug = not is_production
secret_key = (
    environ['STACK_SETUP_SECRET_KEY']
    if is_production
    else 'not-a-secret'
)
