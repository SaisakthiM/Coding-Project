from django.http import HttpResponse
from django.shortcuts import render
import numpy as np
import cv2

def generate_report_card(name, marks):
    img = np.ones((500, 800, 3), dtype=np.uint8) * 255
    cv2.putText(img, f"Report Card for {name}", (50, 100), cv2.FONT_HERSHEY_SIMPLEX, 1.2, (0, 0, 0), 2)
    y = 150
    for subject, mark in marks.items():
        cv2.putText(img, f"{subject}: {mark}", (50, y), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 0, 255), 2)
        y += 40
    _, buffer = cv2.imencode('.png', img)
    return buffer.tobytes()

def index(request):
    name = "John Doe"
    marks = { "Math": 90, "Science": 85, "English": 88 }
    image_data = generate_report_card(name, marks)
    return HttpResponse(image_data, content_type="image/png")
