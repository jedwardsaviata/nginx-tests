FROM nginx:1.13.2

COPY default.conf /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/nginx.conf
COPY port.pl /opt/port.pl
COPY run-nginx.sh /opt/run-nginx.sh

RUN chmod 755 /opt/run-nginx.sh

EXPOSE 8080

WORKDIR /opt

CMD ./run-nginx.sh
