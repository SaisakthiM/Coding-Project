from django.db import models

class Student(models.Model):
    name = models.CharField(max_length=100)
    math = models.IntegerField()
    science = models.IntegerField()
    english = models.IntegerField()
