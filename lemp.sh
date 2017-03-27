#!/bin/bash
sudo setenforce 0

sudo yum install  mariadb-server -y
sudo systemctl enable mariadb
sudo systemctl start mariadb
sudo mv /mysql_secure_installation.sql ./
sudo mysql -sfu root < "mysql_secure_installation.sql"
sudo rm -f mysql_secure_installation.sql
sudo wget -O /etc/my.cnf.d/server.cnf https://raw.githubusercontent.com/maidonghu/centos-gc/master/server.cnf
sudo systemctl restart mariadb

sudo yum install epel-release -y
sudo rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
sudo yum --enablerepo=remi,remi-php71 install php php-mysqlnd php-gd php-xml php-xmlrpc php-mbstring php-mcrypt php-fpm php-opcache php-apcu -y
sudo systemctl enable php-fpm
sudo systemctl restart php-fpm

sudo touch /etc/yum.repos.d/nginx.repo
echo '[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/mainline/centos/7/$basearch/
gpgcheck=0
enabled=1' | sudo tee /etc/yum.repos.d/nginx.repo
sudo yum install nginx -y

sudo systemctl disable httpd
sudo systemctl stop httpd
sudo systemctl enable nginx
sudo systemctl start nginx

cd /var/www/
sudo wget https://wordpress.org/latest.zip
sudo unzip latest.zip
sudo cp -rp wordpress/* html/
sudo chmod 777 html html/wp-content

sudo tuned-adm profile throughput-performance
sudo wget -O /etc/nginx/nginx.conf https://raw.githubusercontent.com/maidonghu/centos-gc/master/nginx.conf
sudo wget -O /etc/nginx/conf.d/http.conf https://raw.githubusercontent.com/maidonghu/centos-ln/master/http.conf
