FROM debian:latest
# Définir le proxy si besoin
RUN echo 'Acquire::http::Proxy "http://192.168.151.254:3128/";' > /etc/apt/apt.conf
RUN echo 'Acquire::https::Proxy "http://192.168.151.254:3128/";' >> /etc/apt/apt.conf
RUN apt update -y
RUN apt install apache2 -y
EXPOSE 80
CMD ["apachectl", "-D", "FOREGROUND"]
