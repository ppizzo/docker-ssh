# docker-ssh
Dockerfile and support files for sshd

Requirements:

The container requires a ssh configuration directory to mount under /usr/local/etc/ssh and a /home/sshuser
home directory to mount under /home.
The user is created during the build and it will be used to connect to the container through ssh.
The etc/ssh configuration directory should also contain public/private server certificates.

To run the container:

$ docker run -d -p 22:22/tcp -v /dev/log:/dev/log -v ${PWD}/etc/:/usr/local/etc/ -v ${PWD}/home/:/home/ IMAGENAME
