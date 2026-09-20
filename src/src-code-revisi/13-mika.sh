#!/bin/sh
apk add --no-cache openssh

rm -rf ~/.ssh
mkdir -p ~/.ssh

ssh-keygen -t rsa -b 2048 -N '' -f ~/.ssh/id_rsa

cat ~/.ssh/id_rsa.pub