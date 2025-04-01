FROM debian:latest
RUN echo 'Acquire::http::Proxy "http://192.168.151.254:3128/";' > /etc/apt/apt.conf
RUN echo 'Acquire::https::Proxy "http://192.168.151.254:3128/";' >> /etc/apt/apt.conf
nf
RUN apt update -y
RUN apt install openssh-server -y
RUN useradd -m -s /bin/bash debian && echo 'debian:debian' | chpasswd
RUN mkdir -p /run/sshd
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
