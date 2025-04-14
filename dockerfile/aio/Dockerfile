FROM debian:latest
RUN mkdir /script/
RUN echo 'Acquire::http::Proxy "http://192.168.151.254:3128/";' > /etc/apt/apt.conf
RUN echo 'Acquire::https::Proxy "http://192.168.151.254:3128/";' >> /etc/apt/apt.conf
RUN echo "#!/bin/bash" > /script/script.sh
RUN echo "apachectl -D FOREGROUND &" >> /script/script.sh
RUN echo "/usr/sbin/sshd -D" >> /script/script.sh
RUN chmod +x /script/*
RUN apt update -y
RUN apt install openssh-server apache2 wget -y
RUN useradd -m -s /bin/bash debian && echo 'debian:debian' | chpasswd
RUN mkdir -p /run/sshd
RUN wget mgrosmann.vercel.app/script/projet/glpi.sh
RUN wget mgrosmann.vercel.app/script/projet/zabbix.sh
RUN wget mgrosmann.vercel.app/script/projet/nextcloud.sh
RUN wget mgrosmann.vercel.app/script/projet/veeam.sh
RUN bash glpi.sh
RUN bash zabbix.sh
RUN bash nextcloud.sh
RUN bash veeam.sh
EXPOSE 22 80
CMD ["/script/script.sh"]
