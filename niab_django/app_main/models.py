from django.db import models


class Settings(models.Model):
    key = models.CharField(max_length=30, primary_key=True)
    value = models.CharField(max_length=255)

    class Meta:
        db_table = 'settings'

class Movies(models.Model):
    id_allocine     = models.CharField(max_length=10, null=False, blank=False, primary_key=True)
    title           = models.CharField(max_length=255, null=True, blank=True)
    release_year    = models.CharField(max_length=4, null=True, blank=True)
    duration_m      = models.CharField(max_length=6, null=True, blank=True)
    public_rating   = models.CharField(max_length=4, null=True, blank=True)
    vote_count      = models.CharField(max_length=10, null=True, blank=True)
    press_rating    = models.CharField(max_length=4, null=True, blank=True)
    audience        = models.CharField(max_length=255, null=True, blank=True)
    synopsis        = models.CharField(max_length=5000, null=True, blank=True)
    poster_link     = models.CharField(max_length=255, null=True, blank=True)
    release_date    = models.CharField(max_length=10, null=True, blank=True)
    societies       = models.CharField(max_length=255, null=True, blank=True)
    budget          = models.CharField(max_length=50, null=True, blank=True)
    nationality     = models.CharField(max_length=255, null=True, blank=True)
    Distributors    = models.CharField(max_length=255, null=True, blank=True)
    pivot_genres    = models.CharField(max_length=1000, null=True, blank=True)
    pivot_directors = models.CharField(max_length=1000, null=True, blank=True)
    pivot_actors    = models.CharField(max_length=1000, null=True, blank=True)

    class Meta:
        db_table = 'movies'

    def __str__(self):
        return f'{self.title}'