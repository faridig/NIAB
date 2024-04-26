from django.urls import path
from app_maquette import views

urlpatterns = [
    path('', views.prediction, name='maquette_prediction'),
    path('film', views.film, name='maquette_film'),
    path('resultat', views.resultat, name='maquette_resultat'),
    path('historique', views.historique, name='maquette_historique'),
]