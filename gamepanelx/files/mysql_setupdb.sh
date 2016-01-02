#!/bin/bash
randpw(){ < /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-16};echo;}
gpx_sql_pass=randpw
gpx_sql_db="gamepanelx"
gpx_sql_usr="gamepanelx"

mysql -uroot -e "CREATE DATABASE IF NOT EXISTS $gpx_sql_db; GRANT ALL ON $gpx_sql_db.* to '$gpx_sql_usr'@'localhost' identified by '$gpx_sql_pass'; FLUSH PRIVILEGES;QUIT;"
