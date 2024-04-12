import pandas as pd
import logging
import niab_mysql


logfile = './logs/pivot_vacances_francaise.log'

# Configuration du logger
# réinitialisation de la log
with open(logfile, 'w') as fichier:
    fichier.write("")
logging.basicConfig(filename=logfile, level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logging.info('§§§ LANCEMENT DU SCRIPT §§§')

# connexion
conn = niab_mysql.analytic_conn()
cur = conn.cursor()

df = pd.read_csv("./chris/vacances scolaires.csv")
logging.info('Liste des colonnes :')
logging.info(df.columns)

df.fillna(0, inplace=True)

request=("TRUNCATE pivot_vacances_francaise")
niab_mysql.request(cur, request, logging)

####################################################################################################
# INSERT EN BOUCLE

line = 0
for index, row in df.iterrows():
    line += 1

    zone = row['zone']
    vacances = row['vacances']
    start_date = row['start_date']
    stop_date = row['stop_date']

    request = f"""
INSERT INTO pivot_vacances_francaise
     VALUES ("{zone}", "{vacances}", "{start_date}", "{stop_date}");
"""
    
    niab_mysql.request(cur, request, logging, line)

####################################################################################################

#déconnexion
conn.commit()
conn.close()

logging.info('§§§ FIN DU SCRIPT §§§')
