FROM nginx:latest

# Remove default nginx HTML
RUN rm -rf /usr/share/nginx/html/*

# Copy React build files
COPY ../frontend/dist/ /usr/share/nginx/html/

# Copy NGINX config
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
