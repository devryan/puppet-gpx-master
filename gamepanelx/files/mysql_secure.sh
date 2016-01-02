#!/bin/bash
randpw(){ < /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-16};echo;}
root_pass=randpw

SECURE_MYSQL=$(expect -c "
set timeout 10
spawn mysql_secure_installation
expect \"Enter current password for root (enter for none):\"
send \"$MYSQL\r\"
expect \"Change the root password?\"
send \"y\r\"
expect \"New password:\"
send \"$root_pass\r\"
expect \"Re-enter new password:\"
send \"$root_pass\r\"
expect \"Remove anonymous users?\"
send \"y\r\"
expect \"Disallow root login remotely?\"
send \"y\r\"
expect \"Remove test database and access to it?\"
send \"y\r\"
expect \"Reload privilege tables now?\"
send \"y\r\"
expect eof
")

# Setup .my.cnf
echo "[client]
host = localhost
user = root
password = "$root_pass"
socket = /var/lib/mysql/mysql.sock" > /root/.my.cnf
chown root:root /root/.my.cnf
chmod 0400 /root/.my.cnf
