from django.db import models


class Settings(models.Model):
    key = models.CharField(max_length=30, primary_key=True)
    value = models.CharField(max_length=255)

    class Meta:
        db_table = 'settings'


class Movies(models.Model):
    id_allocine    = models.IntegerField(null=False, blank=False, primary_key=True)
    title          = models.CharField(max_length=255, null=False, blank=False)
    img_src        = models.CharField(max_length=255, null=True, blank=True)
    release_date   = models.DateField(max_length=10, null=True, blank=True)
    release_year   = models.IntegerField(null=True, blank=True)
    duration       = models.IntegerField(null=True, blank=True)
    pivot_genres   = models.TextField(max_length=1000, null=True, blank=True)
    synopsis       = models.TextField(max_length=5000, null=True, blank=True)
    nationality    = models.TextField(max_length=255, null=True, blank=True)
    distributor    = models.TextField(max_length=255, null=True, blank=True)
    budget         = models.CharField(max_length=50, null=True, blank=True)
    pivot_director = models.TextField(max_length=1000, null=True, blank=True)
    pivot_casting  = models.TextField(max_length=1000, null=True, blank=True)
    public_rating  = models.FloatField(max_length=4, null=True, blank=True)
    vote_count     = models.IntegerField(null=True, blank=True)
    press_rating   = models.FloatField(max_length=4, null=True, blank=True)
    audience       = models.CharField(max_length=255, null=True, blank=True)
    societies      = models.TextField(max_length=255, null=True, blank=True)
    copies         = models.IntegerField(null=True, blank=True)
    pred_entries   = models.IntegerField(null=True, blank=True)
    true_entries   = models.IntegerField(null=True, blank=True)

    class Meta:
        db_table = 'movies_w0'

    def __str__(self):
        return f'{self.title}'


class MoviesW1(models.Model):
    id_allocine    = models.IntegerField(null=False, blank=False, primary_key=True)
    title          = models.CharField(max_length=255, null=False, blank=False)
    img_src        = models.CharField(max_length=255, null=True, blank=True)
    release_date   = models.DateField(max_length=10, null=True, blank=True)
    release_year   = models.IntegerField(null=True, blank=True)
    duration       = models.IntegerField(null=True, blank=True)
    pivot_genres   = models.TextField(max_length=1000, null=True, blank=True)
    synopsis       = models.TextField(max_length=5000, null=True, blank=True)
    nationality    = models.TextField(max_length=255, null=True, blank=True)
    distributor    = models.TextField(max_length=255, null=True, blank=True)
    budget         = models.CharField(max_length=50, null=True, blank=True)
    pivot_director = models.TextField(max_length=1000, null=True, blank=True)
    pivot_casting  = models.TextField(max_length=1000, null=True, blank=True)
    public_rating  = models.FloatField(max_length=4, null=True, blank=True)
    vote_count     = models.IntegerField(null=True, blank=True)
    press_rating   = models.FloatField(max_length=4, null=True, blank=True)
    audience       = models.CharField(max_length=255, null=True, blank=True)
    societies      = models.TextField(max_length=255, null=True, blank=True)
    copies         = models.IntegerField(null=True, blank=True)
    pred_entries   = models.IntegerField(null=True, blank=True)
    true_entries   = models.IntegerField(null=True, blank=True)

    class Meta:
        db_table = 'movies_w1'

    def __str__(self):
        return f'{self.title}'


class MoviesHistory(models.Model):
    id_allocine    = models.IntegerField(null=False, blank=False, primary_key=True)
    title          = models.CharField(max_length=255, null=False, blank=False)
    img_src        = models.CharField(max_length=255, null=True, blank=True)
    release_date   = models.DateField(max_length=10, null=True, blank=True)
    release_year   = models.IntegerField(null=True, blank=True)
    duration       = models.IntegerField(null=True, blank=True)
    pivot_genres   = models.TextField(max_length=1000, null=True, blank=True)
    synopsis       = models.TextField(max_length=5000, null=True, blank=True)
    nationality    = models.TextField(max_length=255, null=True, blank=True)
    distributor    = models.TextField(max_length=255, null=True, blank=True)
    budget         = models.CharField(max_length=50, null=True, blank=True)
    pivot_director = models.TextField(max_length=1000, null=True, blank=True)
    pivot_casting  = models.TextField(max_length=1000, null=True, blank=True)
    public_rating  = models.FloatField(max_length=4, null=True, blank=True)
    vote_count     = models.IntegerField(null=True, blank=True)
    press_rating   = models.FloatField(max_length=4, null=True, blank=True)
    audience       = models.CharField(max_length=255, null=True, blank=True)
    societies      = models.TextField(max_length=255, null=True, blank=True)
    copies         = models.IntegerField(null=True, blank=True)
    pred_entries   = models.IntegerField(null=True, blank=True)
    true_entries   = models.IntegerField(null=True, blank=True)
    history_date   = models.DateField(max_length=10, null=True, blank=True)
    fixed_costs    = models.IntegerField(null=True, blank=True)
    volume         = models.IntegerField(null=True, blank=True)

    class Meta:
        db_table = 'movies_history'

    def __str__(self):
        return f'{self.title}'


class Halls(models.Model):
    hall_name       = models.CharField(max_length=255, null=False, blank=False, primary_key=True)
    number_of_seats = models.IntegerField(null=False, blank=False)
    ticket_price    = models.DecimalField(max_digits=5, decimal_places=2, null=False, blank=False)

    class Meta:
        db_table = 'halls'

    def __str__(self):
        return f'{self.name}'
    