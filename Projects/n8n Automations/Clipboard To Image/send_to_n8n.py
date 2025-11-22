import sys
import requests

image_path = sys.argv[1]
url = "http://localhost:5678/webhook/clip"  # Your n8n Webhook endpoint

with open(image_path, "rb") as img:
    response = requests.post(url, files={"file": img})

print("✅ Sent image to n8n:", response.status_code)
