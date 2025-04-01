FROM debian:latest
RUN echo 'Acquire::http::Proxy "http://192.168.151.254:3128/";' > /etc/apt/apt.conf
RUN echo 'Acquire::https::Proxy "http://192.168.151.254:3128/";' >> /etc/apt/apt.conf
RUN echo "apachectl -D FOREGROUND &" > /tmp/script.sh
echo "apachectl -D FOREGROUND &" >> /tmp/script.sh
echo "/usr/sbin/sshd -D &" >> /tmp/script.sh
RUN apt update -y
RUN apt install openssh-server apache2 -y
RUN useradd -m -s /bin/bash debian && echo 'debian:debian' | chpasswd
RUN mkdir -p /run/sshd
EXPOSE 22 80
CMD ["/tmp/script.sh"]
