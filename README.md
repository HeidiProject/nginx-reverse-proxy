# NGINX Configuration

To enable a microservice architecture for our Heidi project an NGINX reverse proxy was required. This repository contains the details of services currently deployed and supported as well as a framework for seamelessly adding in new services as they are developed.

## nginx.conf

This file contains all of the block instructions for forwarding requests from NGINX to an appropriate backend service. Each block is explained below:

## server blocks 

### http to https forwarding

```nginx
server {
    listen	80;
    server_name heidi.psi.ch;

    return 301 https://$server_name$request_uri;
}
```

## handle https requests

```nginx
server {
  listen	443 ssl;
    server_name heidi.psi.ch;

    ssl_certificate    /etc/certificates/cert.pem;
    ssl_certificate_key    /etc/certificates/cert.key;

    location blocks
}
```

## location blocks

### /

#### Serve Vue 3 web application

```nginx
  location / {
        proxy_pass http://vue-app:5000/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header Cookie $http_cookie;
        proxy_cookie_path / "/; HTTPOnly; Secure";
    }
```

### /auth/api/static_files/

#### Serve static files e.g. PDFs, XLS

```nginx
    location /auth/api/static_files/ {
        proxy_pass http://backend:8000/api/static_files/;
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Cookie $http_cookie;
        proxy_cookie_path / "/; HTTPOnly; Secure";
    }
```

### /auth

#### Authenticate user

```nginx
    location /auth {
        proxy_pass http://backend:8000/;
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

        # Pass the Set-Cookie header to the client
        proxy_pass_header Set-Cookie;

        # Pass access token cookies to the client
        proxy_set_header Cookie $http_cookie;
    }
```

### /auth/api/image

#### Serve sample camera images 

```nginx
    location /auth/api/image/ {
        proxy_pass http://image-server:8443/image/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
```

**`proxy_pass`**: This specifies the backend server's URL to which the request should be proxied. In this case, it is set to https://backend:8000/event-stream.

**`proxy_set_header Host`**: $host is used to pass the original host header

### /auth/api/events 

#### Streaming live data processing results

To enable streaming server-sent events (SSE) from the backend through NGINX, you need to configure NGINX to proxy the request and also modify the response headers to handle SSE correctly. Here's an example configuration:

```nginx
location /auth/api/events {
    proxy_pass https://mxdb-streaming:8008/event-stream;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_http_version 1.1;
    proxy_set_header Connection '';
    proxy_set_header X-Accel-Buffering no;
    proxy_set_header Content-Type text/event-stream;
    proxy_set_header Cache-Control no-cache;
    proxy_set_header Transfer-Encoding chunked;

    proxy_buffering off;
    chunked_transfer_encoding on;
    keepalive_timeout 0;

    proxy_read_timeout 2h;
    proxy_send_timeout 2h;
}
```

**`proxy_pass`**: This specifies the backend server's URL to which the request should be proxied. In this case, it is set to https://backend:8000/event-stream.

**`proxy_set_header Host`**: $host is used to pass the original host header

**`proxy_set_header X-Real-IP`**: $remote_addr sets the real IP address of the client

**`proxy_http_version`**: This sets the HTTP version to 1.1, which is required for server-sent events.

**`proxy_set_header Connection ''`**: This removes the Connection header, allowing the connection to remain open for streaming.

**`proxy_set_header X-Accel-Buffering no`**: This disables buffering of the response from the backend, ensuring that the response is streamed immediately.

**`proxy_set_header Content-Type text/event-stream`**: This sets the Content-Type header to text/event-stream to indicate that the response is an SSE stream.

**`proxy_set_header Cache-Control no-cache`**: This sets the Cache-Control header to no-cache to prevent caching of the SSE response.

**`proxy_set_header Transfer-Encoding chunked`**: This sets the Transfer-Encoding header to chunked to enable chunked transfer encoding for the SSE response.

**`proxy_buffering off`**: This disables buffering of the response from the backend.

**`chunked_transfer_encoding on`**: This enables chunked transfer encoding for the response.

**`keepalive_timeout 0`**: This disables keep-alive connections to ensure the connection remains open for streaming.

**`proxy_read_timeout`** and **`proxy_send_timeout`**: These directives set the read and send timeouts to a long duration (2 hours in this example) to accommodate long-running SSE streams.

With these configurations, NGINX should proxy the request to the backend and handle the SSE response correctly, allowing you to stream server-sent events from the backend through NGINX to the client.