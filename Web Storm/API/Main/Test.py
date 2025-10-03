import requests

url = "https://api.open-meteo.com/v1/forecast"
params = {
    "latitude": 16,    # Chennai latitude
    "longitude": 43,   # Chennai longitude
    "current_weather": True
}

response = requests.get(url, params=params)

if response.status_code == 200:
    data = response.json()
    weather = data["current_weather"]
    print("Temperature:", weather["temperature"], "°C")
    print("Windspeed:", weather["windspeed"], "km/h")
    print("Condition Code:", weather["weathercode"])
else:
    print("Error:", response.status_code)
