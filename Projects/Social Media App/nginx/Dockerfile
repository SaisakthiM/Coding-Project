# frontend/Dockerfile
FROM nginx:alpine

# Remove default Nginx content
RUN rm -rf /usr/share/nginx/html/*

# Copy built static files from the build image

# for React
COPY --from=build /app/build /usr/share/nginx/html  
# for Next.js
# COPY --from=build /app/.next /usr/share/nginx/html  
# Next.js public folder
# COPY --from=build /app/public /usr/share/nginx/html  

# Optional: custom nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
