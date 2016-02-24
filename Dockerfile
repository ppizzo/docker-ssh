FROM ppizzo/armhf-debian

MAINTAINER pietro.pizzo@gmail.com

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get -y dist-upgrade && \
    apt-get install -y openssh-client openssh-server libpam-google-authenticator && \
    useradd -g users -u 1000 -m -s /bin/bash sshuser && \
    su -c "google-authenticator -t -d -f -r 3 -R 30 -w 2" sshuser && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /usr/share/doc* /usr/share/man/* /usr/share/info/*

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
