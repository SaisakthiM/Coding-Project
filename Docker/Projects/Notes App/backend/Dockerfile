FROM python:3.12-slim

WORKDIR /app

COPY . .

RUN pip install --no-cache-dir -r requirements.txt

WORKDIR /app/notes_app

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]



