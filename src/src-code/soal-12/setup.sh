#!/bin/sh
#knights only
apk add --no-cache openssh darkhttpd

ssh-keygen -A
/usr/sbin/sshd

mkdir -p /var/www/localhost/htdocs
darkhttpd /var/www/localhost/htdocs --port 80 &