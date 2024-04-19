from django.shortcuts import render
from django.contrib.auth.decorators import login_required
from .utils import niab_settings
from .models import Movies


def settings():
    settings = niab_settings()
    settings_data = []
    settings_data.append(settings['fixed_costs'])

    return settings_data


def error_404(request, exception):
    return render(request, 'root/404.html', status=404)

@login_required
def prediction(request):
    movies = Movies.objects.all()
    return render(request, 'app_main/prediction.html', {'movies': movies})


@login_required
def film(request):
    return render(request, 'app_main/film.html')


@login_required
def resultat(request):
    settings_data = settings()
    return render(request, 'app_main/resultat.html')

@login_required
def historique(request):
    return render(request, 'app_main/historique.html')
