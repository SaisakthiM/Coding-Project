from django.shortcuts import render

# Create your views here.
def home(request):
    return render(request, 'items/home.html')
def inventory(request):
    return render(request, 'items/inventory.html')
def sell(request):
    return render(request,'items/sell.sell.html')