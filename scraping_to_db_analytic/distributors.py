import pandas as pd
import logging
import niab_mysql


logfile = './logs/pivot_distributors.log'

# Configuration du logger
# réinitialisation de la log
with open(logfile, 'w') as fichier:
    fichier.write("")
logging.basicConfig(filename=logfile, level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logging.info('§§§ LANCEMENT DU SCRIPT §§§')

# connexion
conn = niab_mysql.analytic_conn()
cur = conn.cursor()

df = pd.read_csv("./chris/train_films_distributors.csv")
logging.info('Liste des colonnes :')
logging.info(df.columns)

df.fillna(0, inplace=True)

request=("TRUNCATE pivot_train_films_distributors")
niab_mysql.request(cur, request, logging)

####################################################################################################
# INSERT EN BOUCLE

line = 0
for index, row in df.iterrows():
    line += 1

    budget       = row['budget']
    duration     = row['duration']
    entries      = row['entries']
    film_id      = row['film_id']
    genres       = row['genres']
    img_src      = row['img_src']
    nationality  = row['nationality']
    release_date = row['release']

    try:
        casting = row['casting'].replace('"', '""')
    except:
        casting = ''

    try:
        director = row['director'].replace('"', '""')
    except:
        director = ''

    try:
        distributor = row['distributor'].replace('"', '""')
    except:
        distributor = ''

    try:
        synopsis = row['synopsis'].replace('"', '""')
    except:
        synopsis = ''

    try:
        title = row['title'].replace('"', '""')
    except:
        title = ''

    request = f"""
INSERT INTO pivot_train_films_distributors
     VALUES ("{budget}", "{casting}", "{director}", "{distributor}", {duration},
             {entries}, {film_id}, "{genres}", "{img_src}", "{nationality}",
             "{release_date}", "{synopsis}", "{title}");
"""
    
    niab_mysql.request(cur, request, logging, line)

####################################################################################################

#déconnexion
conn.commit()
conn.close()

logging.info('§§§ FIN DU SCRIPT §§§')
