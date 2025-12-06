from django.urls import path
from . import views

urlpatterns = [
    path('',views.main),
    path('members/',views.members),
    path('details/',views.details_members),
    path('hello_world/',views.hello_world),
    path('testing/',views.testing)
]