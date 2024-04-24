import dot_env
import mysql.connector
import os


# MySQL functional
def functional_conn():
    return mysql.connector.connect(
                host = dot_env.FUNCTIONAL_HOST,
                user = dot_env.FUNCTIONAL_USER,
                password = dot_env.FUNCTIONAL_PASSWORD,
                database = dot_env.FUNCTIONAL_DATABASE,
                port = dot_env.FUNCTIONAL_PORT,
                # ssl_ca=dot_env.FUNCTIONAL_SSL
            )

# Request and logging
def request(cur, request: str, logging, line=0):
    try:
        cur.execute(request)
        if line > 0 and os.getenv("DEBUG") == '1':
            logging.info(f'Ligne n°{line}')
    except Exception as e:
        logging.info(f'Ligne n°{line}')
        if '1062' in str(e):
            logging.warning(e)
        else:
            logging.error(f'Erreur à la ligne {line} : {e}')
            logging.error(request)
