from django.shortcuts import render

def prediction(request):
    return render(request, 'app_main/prediction.html')

def film(request):
    return render(request, 'app_main/film.html')

def resultat(request):
    return render(request, 'app_main/resultat.html')

def historique(request):
    return render(request, 'app_main/historique.html')
