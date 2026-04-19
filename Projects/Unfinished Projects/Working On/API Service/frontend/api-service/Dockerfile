FROM node:24-bookworm-slim

WORKDIR /app

COPY *.json .

RUN npm install

COPY . .

CMD ["npm", "run", "dev"]
