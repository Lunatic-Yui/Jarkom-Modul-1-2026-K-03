#!/bin/sh
apk add --no-cache busybox-extras shadow

adduser -D phantom_user
echo "phantom_user:wired_ghost" | chpasswd

telnetd -p 23 -b 10.65.2.2 &