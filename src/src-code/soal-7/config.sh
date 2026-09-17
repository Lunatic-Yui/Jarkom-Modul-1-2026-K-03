#!/bin/sh
apk add --no-cache shadow vsftpd

adduser -D alice
adduser -D mika
adduser -D eiri

echo "alice:licea123#" | chpasswd
echo "mika:ikam123#" | chpasswd
echo "eiri:riei123#" | chpasswd

usermod -d /var/wired/data alice
usermod -d /var/wired/data mika
usermod -d /var/wired/data eiri

mkdir -p /var/wired/data
chown alice:alice /var/wired/data
chmod 755 /var/wired/data

mkdir -p /etc/vsftpd/user_conf

cat > /etc/vsftpd/vsftpd.conf << 'EOF'
local_enable=YES
write_enable=YES
chroot_local_user=YES
allow_writeable_chroot=YES
userlist_enable=YES 
userlist_file=/etc/vsftpd.userlist
userlist_deny=YES
user_config_dir=/etc/vsftpd/user_conf 
seccomp_sandbox=NO
file_open_mode=0644
EOF

echo "eiri" > /etc/vsftpd.userlist
echo "write_enable=NO" > /etc/vsftpd/user_conf/mika

vsftpd /etc/vsftpd/vsftpd.conf &