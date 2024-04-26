from joblib import load
import pandas as pd

def load_model(path='model.pkl'):
    model = load(path)
    return model

def prediction(model, data):
    df = pd.DataFrame(data, columns=['title', 'genres', 'duration_m', 'synopsis', 'release_date', 'societies', 'nationality', 'directors', 'all_director_oscars', 'all_actor_oscars', 'actor_celebs', 'actor_celebs_by_year', 'entries_mean_actor', 'entries_sum_actor', 'entries_mean_director', 'entries_sum_director', 'entries_mean_composer', 'entries_sum_composer', 'jpbox_copies'])
    predictions = model.predict(df)
    return predictions[0]