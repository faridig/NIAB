import os

if os.getenv('DB_PROD') == '1':
    print('§§§§§§§§§§§§§§§')
    print('§§§ DB PROD §§§')
    print('§§§§§§§§§§§§§§§')
    os.environ["DB_FUNCTIONAL_HOST"] = os.getenv('AZURE_FUNCTIONAL_HOST')
    os.environ["DB_FUNCTIONAL_USER"] = os.getenv('AZURE_FUNCTIONAL_USER')
    os.environ["DB_FUNCTIONAL_PASSWORD"] = os.getenv('AZURE_FUNCTIONAL_PASSWORD')
    os.environ["DB_FUNCTIONAL_DATABASE"] = os.getenv('AZURE_FUNCTIONAL_DATABASE')
    os.environ["DB_FUNCTIONAL_SSL"] = os.getenv('AZURE_FUNCTIONAL_SSL')
else:
    print('§§§§§§§§§§§§§§')
    print('§§§ DB DEV §§§')
    print('§§§§§§§§§§§§§§')
    os.environ["DB_FUNCTIONAL_HOST"] = os.getenv('LOCAL_FUNCTIONAL_HOST')
    os.environ["DB_FUNCTIONAL_USER"] = os.getenv('LOCAL_FUNCTIONAL_USER')
    os.environ["DB_FUNCTIONAL_PASSWORD"] = os.getenv('LOCAL_FUNCTIONAL_PASSWORD')
    os.environ["DB_FUNCTIONAL_DATABASE"] = os.getenv('LOCAL_FUNCTIONAL_DATABASE')
    os.environ["DB_FUNCTIONAL_SSL"] = os.getenv('LOCAL_FUNCTIONAL_SSL')

from .base import *
