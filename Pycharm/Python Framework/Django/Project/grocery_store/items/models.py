from django.db import models

# Create your models here.

class Items(models.Model):
    name = models.CharField(max_length=255)
    price = models.IntegerField()
    category = models.CharField(max_length=255)
    quantity = models.IntegerField()






