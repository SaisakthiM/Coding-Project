FROM python:trixie

WORKDIR /app

COPY requirements.txt .

RUN pip install -r requirements.txt

RUN pip install mysqlclient

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY . .

ENTRYPOINT ["/entrypoint.sh"]