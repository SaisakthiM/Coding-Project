from django.contrib import admin
from django.urls import path
from django.http import HttpResponse
from . import views

urlpatterns = [
    path('',views.home, name = "home"),
    path('room/<str:pk>/',views.room, name="room"),
    path('main/',views.testing,name='testing'),
    path('create-room/',views.create_room,name='create-room'),
    path('update-room/<str:pk>/',views.update_room,name='update-room'),
    path('delete-room/<str:pk>/',views.delete_room,name="delete-room")
]
