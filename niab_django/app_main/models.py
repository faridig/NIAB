from django.db import models

# Create your models here.

class Settings(models.Model):
    key = models.CharField(max_length=30, primary_key=True)
    value = models.CharField(max_length=255)

    class Meta:
        db_table = 'settings'
