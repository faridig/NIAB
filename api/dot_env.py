import dotenv
import os


dotenv.load_dotenv(override=True)

DEBUG = os.environ.get('DEBUG') == '1'

if DEBUG:
    FUNCTIONAL_HOST = os.environ.get("LOCAL_FUNCTIONAL_HOST")
    FUNCTIONAL_USER = os.environ.get("LOCAL_FUNCTIONAL_USER")
    FUNCTIONAL_PASSWORD = os.environ.get("LOCAL_FUNCTIONAL_PASSWORD")
    FUNCTIONAL_DATABASE = os.environ.get("LOCAL_FUNCTIONAL_DATABASE")
    FUNCTIONAL_SSL = os.environ.get("LOCAL_FUNCTIONAL_SSL")
else:
    FUNCTIONAL_HOST = os.environ.get("AZURE_FUNCTIONAL_HOST")
    FUNCTIONAL_USER = os.environ.get("AZURE_FUNCTIONAL_USER")
    FUNCTIONAL_PASSWORD = os.environ.get("AZURE_FUNCTIONAL_PASSWORD")
    FUNCTIONAL_DATABASE = os.environ.get("AZURE_FUNCTIONAL_DATABASE")
    FUNCTIONAL_SSL = os.environ.get("AZURE_FUNCTIONAL_SSL")
