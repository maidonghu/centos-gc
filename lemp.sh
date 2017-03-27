#!/bin/bash
sudo setenforce 0

sudo yum install  mariadb-server -y
sudo systemctl enable mariadb
sudo systemctl start mariadb
sudo mv /mysql_secure_installation.sql ./
sudo mysql -sfu root < "mysql_secure_installation.sql"
sudo rm -f mysql_secure_installation.sql
sudo wget -O /etc/my.cnf.d/server.cnf https://raw.githubusercontent.com/maidonghu/centos-ln/master/server.cnf
