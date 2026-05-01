FROM python:3.12-slim

WORKDIR /app

COPY requirements.txt .

RUN pip install -r requirements.txt --config MYSQLCLIENT_LDFLAGS='pkg-config mysqlclient --libs' --config MYSQLCLIENT_CFLAGS='pkg-config mysqlclient --cflags'

COPY . .

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8000

WORKDIR /app/blogsite

ENTRYPOINT ["/entrypoint.sh"]