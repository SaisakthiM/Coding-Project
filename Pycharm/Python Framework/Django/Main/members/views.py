from django.http import HttpResponse
from django.shortcuts import render
from .models import Member


# Create your views here.

def hello_world(request):
    return render(request,'members/room.html')

def members(request):
    mymembers = Member.objects.all().values()
    context = {
        'mymembers' : mymembers
    }
    return render(request,'members/all_members.html',context)

def details_members(request):
    mymembers = Member.objects.all().values()
    context = {
        'mymembers' : mymembers
    }
    return render(request,'members/details.html',context)

def main(request):
    return render(request,'members/main.html')

def testing(request):
    mymembers = Member.objects.filter(first_name='Sai').values()
    context = {
        'mymembers' : mymembers,
        'firstname' : 'Sai'
    }
    return render(request,'members/testing.html',context)
    
    
