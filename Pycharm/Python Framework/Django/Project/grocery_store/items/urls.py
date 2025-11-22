from django.contrib import admin
from django.urls import path
from .views import home, inventory, sell
urlpatterns = [
    path('home/',home, name='home'),
    path('inventory/',inventory, name='inventory'),
    path('sell/',sell, name='sell')
]