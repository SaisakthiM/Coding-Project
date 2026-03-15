FROM python:3.12-slim

WORKDIR /app

# Copy requirements first → better Docker layer caching
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the project
COPY . .

WORKDIR /app/blogsite

EXPOSE 8000

# Use gunicorn for production (not Django's dev server)
CMD ["gunicorn", "blogsite.wsgi:application", "--bind", "0.0.0.0:8000"]


