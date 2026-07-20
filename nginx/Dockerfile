FROM nginx:latest

# Install gettext-base for envsubst
# RUN apt-get update && apt-get install -y gettext-base && apt-get clean

# Copy over default NGINX configurations (optional, adjust paths as needed)
COPY ./config/nginx.conf.template /etc/nginx/nginx.conf.template


# Configure internal PyPI mirror for DMZ

COPY pip.conf /etc/pip.conf




# Set entrypoint script
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set default command
ENTRYPOINT ["/entrypoint.sh"]
