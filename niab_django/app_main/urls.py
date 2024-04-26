from django.urls import path
from app_main import views

urlpatterns = [
    path('', views.prediction, name='prediction'),
    path('film', views.film, name='film'),
    path('resultat', views.resultat, name='resultat'),
    path('previsionnel', views.previsionnel, name='previsionnel'),
    path('historique', views.historique, name='historique'),
]