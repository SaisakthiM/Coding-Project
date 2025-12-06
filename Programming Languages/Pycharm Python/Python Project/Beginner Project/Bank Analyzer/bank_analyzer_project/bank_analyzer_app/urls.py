from django.urls import path
from . import views

urlpatterns = [
    path('analyze_bank_data/', views.analyze_bank_data, name='analyze_bank_data'),
]