import pandas as pd
import logging
import niab_mysql


logfile = './logs/pivot_jpbox.log'

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
df = pd.read_csv("./chris/jp_box.csv")
logging.info('Liste des colonnes :')
logging.info(df.columns)

df.fillna(0, inplace=True)

request=("TRUNCATE pivot_jpbox")
niab_mysql.request(cur, request, logging)

####################################################################################################
# INSERT EN BOUCLE

line = 0
for index, row in df.iterrows():
    line += 1

    jp_copies = row['jp_copies'].replace(' ', '')

    try:
        jp_director = row['jp_director'].replace('"', '""')
    except:
        jp_director = ''

    try:
        jp_distributors = row['jp_distributors'].replace('"', '""')
    except:
        jp_distributors = ''

    jp_duration = row['jp_duration']

    try:
        jp_genres = row['jp_genres'].replace('"', '""')
    except:
        jp_genres = ''

    try:
        jp_nationality = row['jp_nationality'].replace('"', '""')
    except:
        jp_nationality = ''

    jp_release = row['jp_release']

    try:
        jp_title = row['jp_title'].replace('"', '""')
    except:
        jp_title = ''

    request = f"""
INSERT INTO pivot_jpbox
     VALUES ({jp_copies}, "{jp_director}", "{jp_distributors}", {jp_duration}, "{jp_genres}",
             "{jp_nationality}", "{jp_release}", "{jp_title}");
"""
    
    niab_mysql.request(cur, request, logging, line)

####################################################################################################

#déconnexion
conn.commit()
conn.close()

logging.info('§§§ FIN DU SCRIPT §§§')
