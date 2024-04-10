from django.shortcuts import render

def prediction(request):
    return render(request, 'app_maquette/prediction.html')

def film(request):
    return render(request, 'app_maquette/film.html')

def resultat(request):
    return render(request, 'app_maquette/resultat.html')

def historique(request):
    return render(request, 'app_maquette/historique.html')
