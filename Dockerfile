FROM ppizzo/armhf-jessie

MAINTAINER pietro.pizzo@gmail.com

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get -y dist-upgrade && \
    apt-get install -y openssh-client openssh-server && \
    useradd -g users -u 1000 -m -s /bin/bash sshuser && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /usr/share/doc* /usr/share/man/* /usr/share/info/*

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D" , "-f", "/usr/local/etc/ssh/sshd_config"]
