#!/bin/sh
apk add --no-cache openssh shadow

adduser -D mika_admin

su - mika_admin -c "ssh-keygen -t rsa -b 2048 -N '' -f ~/.ssh/id_rsa"

cat /home/mika_admin/.ssh/id_rsa.pub