#!/bin/sh
apk add --no-cache openssh shadow

ssh-keygen -A
adduser -D mika_admin
echo "mika_admin:suki_13" | chpasswd
mkdir -p /home/mika_admin/.ssh
touch /home/mika_admin/.ssh/authorized_keys
chown -R mika_admin:mika_admin /home/mika_admin/.ssh
chmod 700 /home/mika_admin/.ssh
chmod 600 /home/mika_admin/.ssh/authorized_keys

sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/ssh>
sed -i 's/^PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd>
echo "PasswordAuthentication no" >> /etc/ssh/sshd_config

/usr/sbin/sshd