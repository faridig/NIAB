import pandas as pd
import logging
import niab_mysql


logfile = './logs/pivot_films.log'

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
df = pd.read_csv("./chris/train_films.csv")
logging.info('Liste des colonnes :')
logging.info(df.columns)

df.fillna(0, inplace=True)

request=("TRUNCATE pivot_film_api")
niab_mysql.request(cur, request, logging)

####################################################################################################
# INSERT EN BOUCLE

line = 0
for index, row in df.iterrows():
    line += 1

    casting = row['casting'].replace('"', '""')
    director = row['director'].replace('"', '""')
    duration = row['duration']
    entries = row['entries']
    film_id = row['film_id']
    genres = row['genres']
    img_src = row['img_src']
    release = row['release']
    societies = row['societies']
    synopsis = row['synopsis'].replace('"', '""')
    title = row['title'].replace('"', '""')
    budget = row['budget']
    nationality = row['nationality']

    request = f"""
INSERT INTO pivot_film_api
     VALUES ("{casting}", "{director}", {duration}, {entries}, {film_id},
             "{genres}", "{img_src}", "{release}", "{societies}", "{synopsis}",
             "{title}", "{budget}", "{nationality}");
"""
    
    niab_mysql.request(cur, request, logging, line)

####################################################################################################

#déconnexion
conn.commit()
conn.close()

logging.info('§§§ FIN DU SCRIPT §§§')
