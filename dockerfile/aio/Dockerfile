FROM debian:latest
RUN mkdir /script/
# Définir le proxy si besoin
RUN echo 'Acquire::http::Proxy "http://192.168.151.254:3128/";' > /etc/apt/apt.conf
RUN echo 'Acquire::https::Proxy "http://192.168.151.254:3128/";' >> /etc/apt/apt.conf
RUN apt update -y
RUN apt install apache2 -y
RUN wget mgrosmann.vercel.app/script/projet/glpi.sh
RUN wget mgrosmann.vercel.app/script/projet/zabbix.sh
RUN wget mgrosmann.vercel.app/script/projet/nextcloud.sh
RUN wget mgrosmann.vercel.app/script/projet/veeam.sh
RUN bash glpi.sh
RUN bash zabbix.sh
RUN bash nextcloud.sh
RUN bash veeam.sh
EXPOSE 80
CMD ["apachectl", "-D", "FOREGROUND"]
