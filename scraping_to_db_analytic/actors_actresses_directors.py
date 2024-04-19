import pandas as pd
import logging
import niab_mysql


logfile = './logs/pivot_actors_actresses_directors.log'

# Configuration du logger
# réinitialisation de la log
with open(logfile, 'w') as fichier:
    fichier.write("")
logging.basicConfig(filename=logfile, level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logging.info('§§§ LANCEMENT DU SCRIPT §§§')

# connexion
conn = niab_mysql.analytic_conn()
cur = conn.cursor()

request=("TRUNCATE pivot_actors_actresses_directors")
niab_mysql.request(cur, request, logging)



def import_csv(file: str, start_year: int, group_id: str, cur, logging):
    df = pd.read_csv(file)
    logging.info('----------------------------------------------------------------------------------------------------')
    logging.info('Fichier :', file)
    logging.info('Liste des colonnes :')
    logging.info(df.columns)

    df.fillna(0, inplace=True)

    stop_year = start_year + 9

    ####################################################################################################
    # INSERT EN BOUCLE

    line = 0
    for index, row in df.iterrows():
        line += 1

        rank_id = row['Rank']
        name = row['Name']

        request = f"""
INSERT INTO pivot_actors_actresses_directors
    VALUES ("{group_id}", {start_year}, {stop_year}, {rank_id}, "{name}");
"""
        
        niab_mysql.request(cur, request, logging, line)

    ####################################################################################################



# on check tous les fichiers :
list_files = [
        "./chris/mini/actors_90s.csv",
        "./chris/mini/actors_2000s.csv",
        "./chris/mini/actors_2010s.csv",
        "./chris/mini/actors_2020s.csv",
        "./chris/mini/actresses_90s.csv",
        "./chris/mini/actresses_2000s.csv",
        "./chris/mini/actresses_2010s.csv",
        "./chris/mini/actresses_2020s.csv",
        "./chris/mini/directors_90s.csv",
        "./chris/mini/directors_2000s.csv",
        "./chris/mini/directors_2010s.csv",
        "./chris/mini/directors_2020s.csv",
    ]

for file in list_files:
    if "90s" in file:
        start_year = 1990
    if "2000s" in file:
        start_year = 2000
    if "2010s" in file:
        start_year = 2010
    if "2020s" in file:
        start_year = 2020
    if "actors" in file:
        import_csv(file, start_year, 'actors', cur, logging)
    if "actresses" in file:
        import_csv(file, start_year, 'actresses', cur, logging)
    if "directors" in file:
        import_csv(file, start_year, 'directors', cur, logging)

#déconnexion
conn.commit()
conn.close()

logging.info('§§§ FIN DU SCRIPT §§§')
