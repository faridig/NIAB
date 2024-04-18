from django.shortcuts import render
from django.contrib.auth.decorators import login_required

from datetime import datetime, timedelta
import logging
import pathlib
import os
import json

from .utils import niab_settings, functional_conn, mysql_request
from .models import Movies, Halls


DEBUG =  os.environ.get('DEBUG') == '1'

logfile = str(pathlib.Path(__file__).resolve().parent.parent) + '/logs/app_main.log'
# Configuration du logger
# réinitialisation de la log
# with open(logfile, 'w') as fichier:
#     fichier.write("")
logging.basicConfig(filename=logfile, level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logging.info("§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§")


def settings():
    settings = niab_settings()
    settings_data = []
    settings_data.append(settings['fixed_costs'])

    return settings_data


def error_404(request, exception):
    return render(request, 'root/404.html', status=404)

@login_required
def prediction(request):
    logging.info('--------------------')
    logging.info('def prediction')
    logging.info('--------------------')

    conn = functional_conn()
    cur = conn.cursor()

    movies = Movies.objects.all().order_by('-pred_entries')
    halls = Halls.objects.all().order_by('-number_of_seats')
    # prochain mercredi :
    today = datetime.now() # Trouver la date d'aujourd'hui
    weekday = today.weekday() # Trouver le jour de la semaine (lundi = 0, mardi = 1, ..., dimanche = 6)
    days_until_wednesday = (2 - weekday + 7) % 7 # Calculer le nombre de jours jusqu'au prochain mercredi
    next_wednesday = today + timedelta(days=days_until_wednesday) # Ajouter ces jours à la date d'aujourd'hui pour obtenir la date du prochain mercredi

    if request.method == 'POST':
        # réinitialisation de la table de liens
        niab_request = "DELETE FROM movie_w0_hall;"
        mysql_request(cur, niab_request, logging, "réinitialisation de la table de liens")

        for hall in halls:
            if DEBUG: logging.info("HALL : " + hall.hall_name)
            for movie in movies:
                if DEBUG: logging.info("MOVIE [ " + str(movie.id_allocine) + " ] : " + movie.title)
                if type(request.POST.get(hall.hall_name)) in (int, str):
                    if movie.id_allocine == int(request.POST.get(hall.hall_name)):
                        niab_request = f'''INSERT INTO movie_w0_hall (id_allocine, hall_name)
                                                VALUES ({movie.id_allocine}, "{hall.hall_name}");'''
                        mysql_request(cur, niab_request, logging, "INSERT movie_w0_hall")

    niab_request = "SELECT * FROM w0_movies;"
    movies = mysql_request(cur, niab_request, logging, "SELECT ALL w0_movies")

    conn.commit()
    conn.close()
    
    return render(request, 'app_main/prediction.html', {'movies': movies,
                                                        'halls': halls,
                                                        'next_wednesday': next_wednesday})


@login_required
def film(request):
    logging.info('--------------------')
    logging.info('def film')
    logging.info('--------------------')

    conn = functional_conn()
    cur = conn.cursor()

    id_allocine = int(request.GET.get('id_allocine', '0'))

    niab_request = f'''SELECT *
                        FROM w0_movies
                       WHERE id_allocine = {id_allocine};'''
    movies = mysql_request(cur, niab_request, logging, "SELECT ONE w0_movies")

    conn.commit()
    conn.close()

    return render(request, 'app_main/film.html', {'movies': movies})


@login_required
def resultat(request):
    settings_data = settings()
    return render(request, 'app_main/resultat.html')

@login_required
def historique(request):
    return render(request, 'app_main/historique.html')
