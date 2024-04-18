import pandas as pd
import logging
import niab_mysql


logfile = './logs/pivot_oscars.log'

# Configuration du logger
# réinitialisation de la log
with open(logfile, 'w') as fichier:
    fichier.write("")
logging.basicConfig(filename=logfile, level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logging.info('§§§ LANCEMENT DU SCRIPT §§§')

# connexion
conn = niab_mysql.analytic_conn()
cur = conn.cursor()

df = pd.read_csv("./chris/oscars.csv")
logging.info('Liste des colonnes :')
logging.info(df.columns)

df.fillna(0, inplace=True)

request=("TRUNCATE pivot_oscars")
niab_mysql.request(cur, request, logging)

####################################################################################################
# INSERT EN BOUCLE

line = 0
for index, row in df.iterrows():
    line += 1

    category = row['category']
    winner = row['winner']
    year = row['year']

    request = f"""
INSERT INTO pivot_oscars
     VALUES ("{category}", "{winner}", {year});
"""
    
    niab_mysql.request(cur, request, logging, line)

####################################################################################################

#déconnexion
conn.commit()
conn.close()

logging.info('§§§ FIN DU SCRIPT §§§')
