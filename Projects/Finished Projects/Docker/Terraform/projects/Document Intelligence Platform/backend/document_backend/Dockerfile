FROM python:trixie

WORKDIR /app

COPY requirements.txt .

RUN pip install -r requirements.txt

RUN pip install mysqlclient

COPY . .

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

CMD ["gunicorn", "document_backend.wsgi", "--workers", "3", "--bind", "0.0.0.0:8000"]
