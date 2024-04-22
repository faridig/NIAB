from fastapi import FastAPI
from pydantic import BaseModel
from model_utils import prediction, load_model
import niab_mysql

app = FastAPI()

# Modèle Pydantic pour la structure de données entrantes

class FeaturesInput(BaseModel):
  
    pass
   
class PredictionOut(BaseModel):
    category : float
    
model = load_model()

@app.post('/predict')
def prediction_root(feature_input:FeaturesInput):

    # connexion
    conn = niab_mysql.functional_conn()
    cur = conn.cursor()

    cur.execute("SELECT * FROM db_to_model")

    rows = cur.fetchall()
    print(len(rows))

    for row in rows:
        F0=row[0]      #id
        F1=row[1]      #title
        F2=row[2]      #genres
        F3=row[3]      #duration_m
        F4=row[4]      #synopsis
        F5=row[5]      #release_date
        F6=row[6]      #societies
        F7=row[7]      #nationality
        F8=row[8]      #directors
        F9=row[9]      #all_director_oscars
        F10=row[10]     #all_actor_oscars
        F11=row[11]     #actor_celebs
        F12=row[12]     #actor_celebs_by_year
        F13=row[13]     #entries_mean_actor
        F14=row[14]     #entries_sum_actor
        F15=row[15]     #entries_mean_director
        F16=row[16]     #entries_sum_director
        F17=row[17]     #entries_mean_composer
        F18=row[18]     #entries_sum_composer
        F19=row[19]     #jpbox_copies

        
    
        # try:
        pred = prediction(model,[[F1,F2,F3,F4,F5,F6,F7,F8,F9,F10,F11,F12,F13,F14,F15,F16,F17,F18,F19]])
        

        # UPDATE movies_w0
        # SET prediction = pred
        # WHERE id_allocine = 

        print(F0, pred)

        

        # except:
            # return "erreur dans l'API"            
        


    #déconnexion
    conn.commit()
    conn.close()

    return "réussit"