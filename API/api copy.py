from fastapi import FastAPI
from pydantic import BaseModel
from model_utils import prediction, load_model

app = FastAPI()

# Modèle Pydantic pour la structure de données entrantes

class FeaturesInput(BaseModel):
  
    title: object
    genres: object
    duration_m: int
    synopsis: object
    release_date :object
    societies: object
    nationality: object
    directors: object
    all_director_oscars: int
    all_actor_oscars: int
    actor_celebs: int
    actor_celebs_by_year: int
    entries_mean_actor :int
    entries_sum_actor: int
    entries_mean_director: int
    entries_sum_director: int
    entries_mean_composer :int
    entries_sum_composer: int
    jpbox_copies: int
    
   
class PredictionOut(BaseModel):
    category : float
    
model = load_model()

@app.post('/predict')
def prediction_root(feature_input:FeaturesInput):

    F1=feature_input.title
    F2=feature_input.genres
    F3=feature_input.duration_m
    F4=feature_input.synopsis
    F5=feature_input.release_date
    F6=feature_input.societies
    F7=feature_input.nationality
    F8=feature_input.directors
    F9=feature_input.all_director_oscars
    F10=feature_input.all_actor_oscars
    F11=feature_input.actor_celebs
    F12=feature_input.actor_celebs_by_year
    F13=feature_input.entries_mean_actor
    F14=feature_input.entries_sum_actor
    F15=feature_input.entries_mean_director
    F16=feature_input.entries_sum_director
    F17=feature_input.entries_mean_composer
    F18=feature_input.entries_sum_composer
    F19=feature_input.jpbox_copies

    pred = prediction(model,[[F1,F2,F3,F4,F5,F6,F7,F8,F9,F10,F11,F12,F13,F14,F15,F16,F17,F18,F19]])
    

    return PredictionOut(category=pred)
