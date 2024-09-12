FROM alpine

RUN apk update
RUN apk add sed
RUN apk add bash
RUN apk add openssl
RUN apk add nginx
RUN apk add vim
RUN apk add curl

RUN mkdir -p /run/nginx
RUN sed -i "/include \/etc\/nginx\/http\.d\/\*\.conf/a \ include \/etc\/nginx\/sites-enabled\/*;" /etc/nginx/nginx.conf
RUN sed -i "/access_log/a fastcgi_read_timeout 1d;proxy_read_timeout 1d;" /etc/nginx/nginx.conf
RUN sed -i "s/client_max_body_size 1m/client_max_body_size 0/" /etc/nginx/nginx.conf
RUN rm -f /etc/nginx/http.d/default.conf
RUN echo -e "\nserver {\n  listen 80;\n  server_name localhost;\n  location /health {\n    return 200 'OK';\n    add_header Content-Type text/plain;\n  }\n}" >> /etc/nginx/http.d/health.conf

RUN mkdir -p /etc/nginx/sites-enabled/
RUN mkdir -p /etc/nginx/sites-available/
RUN rm -f /etc/nginx/sites-enabled/default

COPY ./src/clear-sites.sh /app/clear-sites.sh
COPY ./src/add-site.sh /app/add-site.sh
COPY ./src/reload.sh /app/reload.sh

EXPOSE 80
EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]