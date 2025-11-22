FROM python:3.12-slim

WORKDIR /app

COPY . .

RUN apt-get update && apt-get install -y postgresql-client && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir -r requirements.txt

WORKDIR /app/notes_app

RUN chmod +x /app/notes_app/wait-for-postgres.sh

# don't run migrate directly yet
CMD ["./wait-for-postgres.sh", "notes-postgres", "python", "manage.py", "runserver", "0.0.0.0:8000"]



