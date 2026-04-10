#!/bin/bash

useradd -m -d /var/www/html/wordpress ${FTP_USER}
echo "${FTP_USER}:${FTP_PASSWORD}" | chpasswd
chown -R ${FTP_USER}:${FTP_USER} /var/www/html/wordpress

exec vsftpd /etc/vsftpd.conf
