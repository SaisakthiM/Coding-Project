from django.shortcuts import render
from django.http import JsonResponse

def post_list(request):
    data = [
        {"id": 1, "title": "First Post"},
        {"id": 2, "title": "Second Post"},
    ]
    return JsonResponse(data, safe=False)

