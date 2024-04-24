from django.shortcuts import render
from django.contrib.auth.decorators import login_required

from datetime import datetime, timedelta
import logging
import pathlib
import os

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


def settings(key):
    settings = niab_settings()
    settings_data = []
    settings_data.append(settings[key])

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
def previsionnel(request):
    logging.info('--------------------')
    logging.info('def film')
    logging.info('--------------------')

    fixed_costs = settings('fixed_costs')[0]
    volume = settings('volume')[0]

    conn = functional_conn()
    cur = conn.cursor()
    
    niab_request = f'''SELECT mw.id_allocine,
                              mw.title,
                              CASE
                                WHEN ROUND(mw.pred_entries / {volume}) > h.number_of_seats * 7 THEN h.number_of_seats * 7
                                ELSE ROUND(mw.pred_entries / {volume})
                              END AS pred_entries_week,
                              ROUND (CASE
                                WHEN ROUND(mw.pred_entries / {volume}) > h.number_of_seats * 7 THEN h.number_of_seats * 7
                                ELSE ROUND(mw.pred_entries / {volume})
                              end / 7) AS pred_entries_day,
                              CASE
                                WHEN ROUND(mw.pred_entries / {volume}) > h.number_of_seats * 7 THEN h.number_of_seats * 7
                                ELSE ROUND(mw.pred_entries / {volume})
                              END * h.ticket_price AS ca,
                              h.*
                         FROM movies_w0 mw
                         JOIN movie_w0_hall mwh on mwh.id_allocine = mw.id_allocine
                         JOIN halls h on h.hall_name = mwh.hall_name
                     ORDER BY h.number_of_seats DESC'''
    pred_movies = mysql_request(cur, niab_request, logging, "SELECT ALL pred_movies")
    
    niab_request = f'''SELECT SUM(CASE
                                WHEN ROUND(mw.pred_entries / {volume}) > h.number_of_seats * 7 THEN h.number_of_seats * 7
                                ELSE ROUND(mw.pred_entries / {volume})
                              END * h.ticket_price) AS ca
                         FROM movies_w0 mw
                         JOIN movie_w0_hall mwh on mwh.id_allocine = mw.id_allocine
                         JOIN halls h on h.hall_name = mwh.hall_name'''
    ca = mysql_request(cur, niab_request, logging, "SELECT ONE ca")
    
    niab_request = f'''SELECT SUM(CASE
                                WHEN ROUND(mw.pred_entries / {volume}) > h.number_of_seats * 7 THEN h.number_of_seats * 7
                                ELSE ROUND(mw.pred_entries / {volume})
                              END * h.ticket_price) - {fixed_costs} AS fin_result
                         FROM movies_w0 mw
                         JOIN movie_w0_hall mwh on mwh.id_allocine = mw.id_allocine
                         JOIN halls h on h.hall_name = mwh.hall_name'''
    fin_result = mysql_request(cur, niab_request, logging, "SELECT ONE fin_result")

    conn.commit()
    conn.close()

    return render(request, 'app_main/previsionnel.html', {
                                                        'pred_movies': pred_movies,
                                                        'ca': ca,
                                                        'fixed_costs': fixed_costs,
                                                        'fin_result': fin_result,
                                                     })


@login_required
def resultat(request):
    logging.info('--------------------')
    logging.info('def film')
    logging.info('--------------------')

    fixed_costs = settings('fixed_costs')[0]
    volume = settings('volume')[0]

    conn = functional_conn()
    cur = conn.cursor()
    
    niab_request = f'''SELECT mw.id_allocine,
                              h.hall_name,
                              mw.title,
                              CASE
                                WHEN ROUND(mw.pred_entries / {volume}) > h.number_of_seats * 7 THEN h.number_of_seats * 7
                                ELSE ROUND(mw.pred_entries / {volume})
                              END AS pred_entries_week,
                              CASE
                                WHEN ROUND(mw.true_entries / {volume}) > h.number_of_seats * 7 THEN h.number_of_seats * 7
                                ELSE ROUND(mw.true_entries / {volume})
                              END AS true_entries_week,
                              CASE
                                WHEN ROUND(mw.pred_entries / {volume}) > h.number_of_seats * 7 THEN h.number_of_seats * 7
                                ELSE ROUND(mw.pred_entries / {volume})
                              END * h.ticket_price AS pred_ca,
                              CASE
                                WHEN ROUND(mw.true_entries / {volume}) > h.number_of_seats * 7 THEN h.number_of_seats * 7
                                ELSE ROUND(mw.true_entries / {volume})
                              END * h.ticket_price AS true_ca
                         FROM movies_w1 mw
                         JOIN movie_w1_hall mwh on mwh.id_allocine = mw.id_allocine
                         JOIN halls h on h.hall_name = mwh.hall_name
                     ORDER BY h.number_of_seats DESC'''
    true_movies = mysql_request(cur, niab_request, logging, "SELECT ALL true_movies")

    niab_request = f'''SELECT SUM(CASE
                                WHEN ROUND(mw.pred_entries / {volume}) > h.number_of_seats * 7 THEN h.number_of_seats * 7
                                ELSE ROUND(mw.pred_entries / {volume})
                              END * h.ticket_price) AS pred_ca,
                              SUM(CASE
                                WHEN ROUND(mw.true_entries / {volume}) > h.number_of_seats * 7 THEN h.number_of_seats * 7
                                ELSE ROUND(mw.true_entries / {volume})
                              END * h.ticket_price) AS true_ca
                         FROM movies_w1 mw
                         JOIN movie_w1_hall mwh on mwh.id_allocine = mw.id_allocine
                         JOIN halls h on h.hall_name = mwh.hall_name'''
    ca = mysql_request(cur, niab_request, logging, "SELECT ONE ca")
    
    niab_request = f'''SELECT SUM(CASE
                                WHEN ROUND(mw.pred_entries / {volume}) > h.number_of_seats * 7 THEN h.number_of_seats * 7
                                ELSE ROUND(mw.pred_entries / {volume})
                              END * h.ticket_price) - {fixed_costs} AS pred_result,
                              SUM(CASE
                                WHEN ROUND(mw.true_entries / {volume}) > h.number_of_seats * 7 THEN h.number_of_seats * 7
                                ELSE ROUND(mw.true_entries / {volume})
                              END * h.ticket_price) - {fixed_costs} AS true_result
                         FROM movies_w1 mw
                         JOIN movie_w1_hall mwh on mwh.id_allocine = mw.id_allocine
                         JOIN halls h on h.hall_name = mwh.hall_name'''
    fin_result = mysql_request(cur, niab_request, logging, "SELECT ONE fin_result")

    conn.commit()
    conn.close()

    return render(request, 'app_main/resultat.html', {
                                                        'true_movies': true_movies,
                                                        'fixed_costs': fixed_costs,
                                                        'ca': ca,
                                                        'fin_result': fin_result,
                                                     })

@login_required
def historique(request):
    logging.info('--------------------')
    logging.info('def historique')
    logging.info('--------------------')

    fixed_costs = settings('fixed_costs')[0]
    volume = settings('volume')[0]

    conn = functional_conn()
    cur = conn.cursor()
    
    niab_request = f'''  SELECT mh.history_date,
                                GROUP_CONCAT(mh.title SEPARATOR ' / ') titles,
                                AVG(mh.fixed_costs) fixed_costs,
                                AVG(mh.volume) volume,
                                SUM(mh.pred_entries) pred_entries,
                                SUM(mh.true_entries) true_entries,
                                SUM(CASE
                                        WHEN ROUND(mh.pred_entries / {volume}) > h.number_of_seats * 7
                                            THEN h.number_of_seats * 7
                                        ELSE ROUND(mh.pred_entries / {volume})
                                    END) AS pred_entries_week,
                                SUM(CASE
                                        WHEN ROUND(mh.true_entries / {volume}) > h.number_of_seats * 7
                                            THEN h.number_of_seats * 7
                                        ELSE ROUND(mh.true_entries / {volume})
                                    END) AS true_entries_week,
                                SUM(CASE
                                        WHEN ROUND(mh.pred_entries / {volume}) > h.number_of_seats * 7
                                            THEN ROUND(mh.pred_entries / {volume})
                                        ELSE 0
                                    END) AS max_pred_entries_week,
                                SUM(CASE
                                        WHEN ROUND(mh.true_entries / {volume}) > h.number_of_seats * 7
                                            THEN ROUND(mh.true_entries / {volume})
                                        ELSE 0
                                    END) AS max_true_entries_week,
                                SUM(CASE
                                        WHEN ROUND(mh.pred_entries / {volume}) > h.number_of_seats * 7
                                            THEN h.number_of_seats * 7
                                        ELSE ROUND(mh.pred_entries / {volume})
                                    END * mhh.ticket_price) AS pred_result,
                                SUM(CASE
                                        WHEN ROUND(mh.true_entries / {volume}) > h.number_of_seats * 7
                                            THEN h.number_of_seats * 7
                                        ELSE ROUND(mh.true_entries / {volume})
                                    END * mhh.ticket_price) AS true_result,
                                GROUP_CONCAT(h.hall_name SEPARATOR '<br>') infos_hall,
                                GROUP_CONCAT(mh.title SEPARATOR '<br>') infos_hall,
                                GROUP_CONCAT(mh.pred_entries SEPARATOR '<br>') infos_hall,
                                GROUP_CONCAT(mh.true_entries SEPARATOR '<br>') infos_hall,
                                GROUP_CONCAT(CASE
                                        WHEN ROUND(mh.pred_entries / {volume}) > h.number_of_seats * 7
                                            THEN h.number_of_seats * 7
                                        ELSE ROUND(mh.pred_entries / {volume})
                                    END SEPARATOR '<br>') infos_hall,
                                GROUP_CONCAT(CASE
                                        WHEN ROUND(mh.true_entries / {volume}) > h.number_of_seats * 7
                                            THEN h.number_of_seats * 7
                                        ELSE ROUND(mh.true_entries / {volume})
                                    END SEPARATOR '<br>') infos_hall,
                                GROUP_CONCAT(CASE
                                        WHEN ROUND(mh.pred_entries / {volume}) > h.number_of_seats * 7
                                            THEN ROUND(mh.pred_entries / {volume})
                                        ELSE 0
                                    END SEPARATOR '<br>') infos_hall,
                                GROUP_CONCAT(CASE
                                        WHEN ROUND(mh.true_entries / {volume}) > h.number_of_seats * 7
                                            THEN ROUND(mh.true_entries / {volume})
                                        ELSE 0
                                    END SEPARATOR '<br>') infos_hall,
                                GROUP_CONCAT(CASE
                                        WHEN ROUND(mh.pred_entries / {volume}) > h.number_of_seats * 7
                                            THEN h.number_of_seats * 7
                                        ELSE ROUND(mh.pred_entries / {volume})
                                    END * mhh.ticket_price SEPARATOR '€<br>') infos_hall,
                                GROUP_CONCAT(CASE
                                        WHEN ROUND(mh.true_entries / {volume}) > h.number_of_seats * 7
                                            THEN h.number_of_seats * 7
                                        ELSE ROUND(mh.true_entries / {volume})
                                    END * mhh.ticket_price SEPARATOR '€<br>') infos_hall
                           FROM movies_history mh
                           JOIN movie_history_hall mhh ON mhh.id_allocine = mh.id_allocine
                           JOIN halls h ON h.hall_name = mhh.hall_name
                       GROUP BY mh.history_date
                       ORDER BY mh.history_date DESC'''
    histories = mysql_request(cur, niab_request, logging, "SELECT ALL histories")

    conn.commit()
    conn.close()

    return render(request, 'app_main/historique.html', {
                                                        'histories': histories,
                                                     })
