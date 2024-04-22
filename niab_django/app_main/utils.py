from .models import Settings

import mysql.connector
import os


def niab_settings():
    keys_values = Settings.objects.all()
    settings = {}
    for key_value in keys_values:
        settings[key_value.key] = key_value.value
    return settings


# MySQL functional
def functional_conn():
    return mysql.connector.connect(
            host = os.getenv('DB_FUNCTIONAL_HOST'),
            user = os.getenv('DB_FUNCTIONAL_USER'),
            password = os.getenv('DB_FUNCTIONAL_PASSWORD'),
            database = os.getenv('DB_FUNCTIONAL_DATABASE'),
            ssl_ca=os.getenv('DB_FUNCTIONAL_SSL')
        )

# Request and logging
def mysql_request(cur, request: str, logging, info):
    logging.info('# MySQL # : ' + info)
    try:
        cur.execute(request)
        return cur.fetchall()
    except Exception as e:
        if '1062' in str(e):
            logging.warning(e)
        else:
            logging.error(f"Erreur : {e}")
            logging.error(request)
