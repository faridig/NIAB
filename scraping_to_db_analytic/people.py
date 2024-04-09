import pandas as pd
import logging
import niab_mysql


logfile = './logs/pivot_people.log'

# Configuration du logger
# réinitialisation de la log
with open(logfile, 'w') as fichier:
    fichier.write("")
logging.basicConfig(filename=logfile, level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logging.info('§§§ LANCEMENT DU SCRIPT §§§')

# connexion
conn = niab_mysql.analytic_conn()
cur = conn.cursor()

# df = pd.read_csv("./chris/films.csv")
df = pd.read_csv("./chris/people.csv")
logging.info('Liste des colonnes :')
logging.info(df.columns)

df.fillna(0, inplace=True)

request=("TRUNCATE pivot_people")
niab_mysql.request(cur, request, logging)

####################################################################################################
# INSERT EN BOUCLE

line = 0
for index, row in df.iterrows():
    line += 1

    entries_mean = row['entries_mean']
    entries_sum = row['entries_sum']

    try:
        name = row['name'].replace('"', '""')
    except:
        name = ''

    person_id = row['person_id']

    try:
        role = row['role'].replace('"', '""')
    except:
        role = ''

    request = f"""
INSERT INTO pivot_people
     VALUES ({entries_mean}, {entries_sum}, "{name}", {person_id}, "{role}");
"""
    
    niab_mysql.request(cur, request, logging, line)

####################################################################################################

#déconnexion
conn.commit()
conn.close()

logging.info('§§§ FIN DU SCRIPT §§§')
