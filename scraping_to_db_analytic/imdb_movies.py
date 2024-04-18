import pandas as pd
import logging
import niab_mysql


logfile = './logs/pivot_imdb_movies.log'

# Configuration du logger
# réinitialisation de la log
with open(logfile, 'w') as fichier:
    fichier.write("")
logging.basicConfig(filename=logfile, level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logging.info('§§§ LANCEMENT DU SCRIPT §§§')

# connexion
conn = niab_mysql.analytic_conn()
cur = conn.cursor()

df = pd.read_csv("./chris/imdb_movies.csv")
logging.info('Liste des colonnes :')
logging.info(df.columns)

df.fillna(0, inplace=True)

request=("TRUNCATE pivot_imdb_movies")
niab_mysql.request(cur, request, logging)

####################################################################################################
# INSERT EN BOUCLE

line = 0
for index, row in df.iterrows():
    line += 1

    movie_boxoffice = row['movie_boxoffice']
    movie_budget = row['movie_budget']
    movie_cast = str(row['movie_cast']).replace('"', '""')
    movie_categories = str(row['movie_categories']).replace('"', '""')
    movie_countries = str(row['movie_countries']).replace('"', '""')
    movie_director = str(row['movie_director']).replace('"', '""')
    movie_id = row['movie_id']
    movie_imdb_metascore = row['movie_imdb_metascore']
    movie_imdb_nb_of_ratings = row['movie_imdb_nb_of_ratings']
    movie_imdb_popularity = row['movie_imdb_popularity']
    movie_imdb_rating = row['movie_imdb_rating']
    movie_length = row['movie_length']
    movie_original_title = str(row['movie_original_title']).replace('"', '""')
    movie_production_companies = str(row['movie_production_companies']).replace('"', '""')
    movie_synopsis = str(row['movie_synopsis']).replace('"', '""')
    movie_title = str(row['movie_title']).replace('"', '""')
    movie_url = row['movie_url']
    movie_us_boxoffice = row['movie_us_boxoffice']
    release_year = row['year']

    request = f"""
INSERT INTO pivot_imdb_movies
     VALUES ({movie_boxoffice}, "{movie_budget}", "{movie_cast}", "{movie_categories}", "{movie_countries}",
             "{movie_director}", "{movie_id}", {movie_imdb_metascore}, {movie_imdb_nb_of_ratings}, {movie_imdb_popularity},
             {movie_imdb_rating}, {movie_length}, "{movie_original_title}", "{movie_production_companies}", "{movie_synopsis}",
             "{movie_title}", "{movie_url}", {movie_us_boxoffice}, {release_year});
"""
    
    niab_mysql.request(cur, request, logging, line)

####################################################################################################

#déconnexion
conn.commit()
conn.close()

logging.info('§§§ FIN DU SCRIPT §§§')
