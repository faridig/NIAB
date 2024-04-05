from django.shortcuts import render

def home_page(request):
    return render(request, 'app_maquette/home_page.html')
