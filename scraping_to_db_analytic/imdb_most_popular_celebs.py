import pandas as pd
import logging
import niab_mysql


logfile = './logs/pivot_imdb_most_popular_celebs.log'

# Configuration du logger
# réinitialisation de la log
with open(logfile, 'w') as fichier:
    fichier.write("")
logging.basicConfig(filename=logfile, level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logging.info('§§§ LANCEMENT DU SCRIPT §§§')

# connexion
conn = niab_mysql.analytic_conn()
cur = conn.cursor()

df = pd.read_csv("./chris/imdb_most_popular_celebs.csv")
logging.info('Liste des colonnes :')
logging.info(df.columns)

df.fillna(0, inplace=True)

request=("TRUNCATE pivot_imdb_most_popular_celebs")
niab_mysql.request(cur, request, logging)

####################################################################################################
# INSERT EN BOUCLE


for index, row in df.iterrows():
    line = 0

    celebrity = row['celebrity']

    names = celebrity.split(',')

    for index, name in enumerate(names):
        line += 1
        request = f"""
INSERT INTO pivot_imdb_most_popular_celebs
     VALUES ({index + 1}, "{name}");
"""
        niab_mysql.request(cur, request, logging, line)

####################################################################################################

#déconnexion
conn.commit()
conn.close()

logging.info('§§§ FIN DU SCRIPT §§§')
