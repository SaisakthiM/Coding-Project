FROM node:22-alpine

COPY index.html .
COPY server.js .
COPY package.json .

RUN npm install 

EXPOSE 8000

CMD ["npm", "run", "dev"]
