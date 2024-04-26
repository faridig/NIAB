#!/bin/sh

# Charger les variables d'environnement à partir du fichier .env
export $(egrep -v '^#' .env | xargs)

while ! nc -z $AZURE_FUNCTIONAL_HOST 3306; do
    echo "En attente de MySQL Azure..."
    sleep 1
done

echo "Effectuer les migrations"
python manage.py makemigrations && python manage.py migrate

python manage.py collectstatic --no-input

echo "Lancer le serveur"

gunicorn niab_django.wsgi:application --workers=4 --timeout 120 --bind=0.0.0.0:80