import pandas as pd
import logging
import niab_mysql


logfile = './pivot_films.log'

# Configuration du logger
# réinitialisation de la log
with open(logfile, 'w') as fichier:
    fichier.write("")
logging.basicConfig(filename=logfile, level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logging.info('§§§ LANCEMENT DU SCRIPT §§§')

# connexion
conn = niab_mysql.analytic_conn()
cur = conn.cursor()

df = pd.read_csv("./chris/films.csv")
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

    casting = row['casting']
    director = row['director']
    duration = row['duration']
    entries = row['entries']
    film_id = row['film_id']
    genres = row['genres']
    img_src = row['img_src']
    press_ratings = row['press_ratings']
    release = row['release']
    societies = row['societies']
    synopsis = row['synopsis'].replace('"', '""')
    title = row['title'].replace('"', '""')
    viewers_ratings = row['viewers_ratings']

    request = f"""
INSERT INTO pivot_film_api
     VALUES ("{casting}", "{director}", {duration}, {entries}, {film_id},
             "{genres}", "{img_src}", {press_ratings}, "{release}", "{societies}",
             "{synopsis}", "{title}", {viewers_ratings});
"""
    
    niab_mysql.request(cur, request, logging, line)

####################################################################################################

#déconnexion
conn.commit()
conn.close()

logging.info('§§§ FIN DU SCRIPT §§§')
