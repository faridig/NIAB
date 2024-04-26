# pour récupérer les données de la BDD analytique vers un fichier csv exploitable pour l'EDA

import dot_env
import mysql.connector
import csv
import os


parent_directory = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
csv_file = os.path.join(parent_directory, 'EDA.csv')

####################################################################################################
# MySQL

conn = mysql.connector.connect(
        host = dot_env.ANALYTIC_HOST,
        user = dot_env.ANALYTIC_USER,
        password = dot_env.ANALYTIC_PASSWORD,
        database = dot_env.ANALYTIC_DATABASE,
        ssl_ca=dot_env.ANALYTIC_SSL
    )
cur = conn.cursor()

cur.execute("SELECT * FROM db_to_ml")
rows = cur.fetchall()

#déconnexion
conn.commit()
conn.close()

####################################################################################################
# CSV

with open(csv_file, 'w', newline='') as csvfile:
    writer = csv.writer(csvfile)
    # Écriture de l'en-tête avec les noms des colonnes
    writer.writerow([i[0] for i in cur.description])
    # Écriture des données de chaque ligne
    for row in rows:
        writer.writerow(row)
