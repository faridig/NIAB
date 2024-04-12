import dotenv
import os


dotenv.load_dotenv(override=True)

DEBUG = os.environ.get('DEBUG') == '1'

if DEBUG:
    ANALYTIC_HOST = os.environ.get("LOCAL_ANALYTIC_HOST")
    ANALYTIC_USER = os.environ.get("LOCAL_ANALYTIC_USER")
    ANALYTIC_PASSWORD = os.environ.get("LOCAL_ANALYTIC_PASSWORD")
    ANALYTIC_DATABASE = os.environ.get("LOCAL_ANALYTIC_DATABASE")
    ANALYTIC_SSL = os.environ.get("LOCAL_ANALYTIC_SSL")
else:
    ANALYTIC_HOST = os.environ.get("AZURE_ANALYTIC_HOST")
    ANALYTIC_USER = os.environ.get("AZURE_ANALYTIC_USER")
    ANALYTIC_PASSWORD = os.environ.get("AZURE_ANALYTIC_PASSWORD")
    ANALYTIC_DATABASE = os.environ.get("AZURE_ANALYTIC_DATABASE")
    ANALYTIC_SSL = os.environ.get("AZURE_ANALYTIC_SSL")
