from django.shortcuts import render
from .utils import niab_settings

def prediction(request):
    settings = niab_settings()
    data = []
    data.append(settings['fixed_costs'])
    return render(request, 'app_main/prediction.html', {'data': data})

def film(request):
    return render(request, 'app_main/film.html')

def resultat(request):
    return render(request, 'app_main/resultat.html')

def historique(request):
    return render(request, 'app_main/historique.html')
