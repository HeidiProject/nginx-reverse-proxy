# Base image with Nginx installed
FROM nginx:latest

# Remove default Nginx configurations
# RUN rm /etc/nginx/conf.d/default.conf

# Copy custom Nginx configuration
COPY config/nginx.conf /etc/nginx/conf.d/

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]

