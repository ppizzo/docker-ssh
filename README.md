# docker-ssh
Dockerfile and support files for sshd with Google Authenticator

## Requirements

The container requires a ssh configuration directory to mount under `/etc/ssh`, a user home directory to mount under `/home` and a sshd PAM configuration file to mount under `/etc/pam.d/sshd`.

You can extract those files/directories directly from the container after the build, copy on a local directory on the Docker engine host and mount as volumes as showed later in this document.

The `/etc/ssh` configuration directory will contain public/private server certificates generated during the build; in `$HOME/.ssh` you must put an `authorized_keys` file with your own RSA public key(s).

Since the token configuration is time-based, your system must run an `ntp` agent in order to keep the time synchronized with the device generating the codes.

## Build

You are free to modify the `Dockerfile` accordingly to your environment. The items you might want to modify are the following:

- image to start FROM: you can use a Debian-based distribution of your choice
- username (`sshuser` in the Dockerfile)
- Google Authenticator options (but the default options should be fine for average use)

To build the container run the following command:

```
$ docker build -t ssh .
```

The build procedure configures Google Authenticator and leaves the configuration in user's home directory in `.google_authenticator` file. It also shows the secret keys during the build along with an URL where you can fetch the QR code to use with Google Authenticator. You can also use the provided secret keys to configure the Google Authenticator app.

**PLEASE NOTICE: don't forget to store the secrets in a safe place!**

The user created during the build will be the one you must use to connect to the container through ssh.

## Configuration

The first piece of configuration is stored in the `.google_authenticator` file created in the user's home directory during the build. You can generate a fresh configuration by running the `google-authenticator` executable inside the container.

To activate the two factor authentication with public/private keys you need to modify the container `/etc/ssh/sshd` file as showed below:

```
ChallengeResponseAuthentication yes
AuthenticationMethods publickey,keyboard-interactive
UsePAM yes
```
and configure other SSH options as per your requirements.

Then you must activate the Google Authenticator PAM module by adding the following line at the beginning of `/etc/pam.d/sshd` file:

```
# Google Authenticator
auth [success=done new_authtok_reqd=done default=die] pam_google_authenticator.so nullok
```

If you want to enable password as well (three factor authentication: keys, token and password) use the following line in the PAM configuration file instead of the line provided above:

```
auth required pam_google_authenticator.so
```

## Running

To run the container:

```
$ docker run -d --restart always \
  --privileged -p 22:22/tcp \
  -v /dev/log:/dev/log \
  -v ${PWD}/etc/ssh:/etc/ssh \
  -v ${PWD}/etc/pam.d/sshd:/etc/pam.d/sshd \
  -v ${PWD}/home/:/home/ \
  --name ssh ssh
```

## References

https://github.com/google/google-authenticator

https://play.google.com/store/apps/details?id=com.google.android.apps.authenticator2