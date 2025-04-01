FROM debian:latest
RUN mkdir /script/
RUN echo 'Acquire::http::Proxy "http://192.168.151.254:3128/";' > /etc/apt/apt.conf
RUN echo 'Acquire::https::Proxy "http://192.168.151.254:3128/";' >> /etc/apt/apt.conf
RUN echo "apachectl -D FOREGROUND &" > /script/script.sh
RUN echo "/usr/sbin/sshd -D" >> /script/script.sh
RUN chmod +x /script/*
RUN apt update -y
RUN apt install openssh-server apache2 -y
RUN useradd -m -s /bin/bash debian && echo 'debian:debian' | chpasswd
RUN mkdir -p /run/sshd
EXPOSE 22 80
CMD ["/script/script.sh"]
