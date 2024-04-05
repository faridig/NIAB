from django.urls import path
from app_maquette import views

urlpatterns = [
    path('', views.home_page, name='home'),
]