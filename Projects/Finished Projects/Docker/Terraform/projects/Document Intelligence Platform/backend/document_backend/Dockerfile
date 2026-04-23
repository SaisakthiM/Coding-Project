FROM python:trixie

WORKDIR /app

COPY requirements.txt .

RUN pip install -r requirements.txt
RUN pip install mysqlclient

COPY . .

CMD ["gunicorn", "document_backend.wsgi","--workers 3", "--bind", "0.0.0.0:8000"]
