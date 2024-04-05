import os

os.environ["DB_FUNCTIONAL_HOST"] = os.getenv('AZURE_FUNCTIONAL_HOST')
os.environ["DB_FUNCTIONAL_USER"] = os.getenv('AZURE_FUNCTIONAL_USER')
os.environ["DB_FUNCTIONAL_PASSWORD"] = os.getenv('AZURE_FUNCTIONAL_PASSWORD')
os.environ["DB_FUNCTIONAL_DATABASE"] = os.getenv('AZURE_FUNCTIONAL_DATABASE')
os.environ["DB_FUNCTIONAL_SSL"] = os.getenv('AZURE_FUNCTIONAL_SSL')

from .base import *
