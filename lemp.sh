#!/bin/bash
sudo setenforce 0

sudo touch /etc/yum.repos.d/MariaDB.repo
echo '# MariaDB 10.1 CentOS repository list - created 2017-04-02 05:25 UTC
# http://downloads.mariadb.org/mariadb/repositories/
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.1/centos7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1' | sudo tee /etc/yum.repos.d/MariaDB.repo

sudo yum install -y MariaDB-server MariaDB-client
sudo systemctl enable mariadb
sudo systemctl start mariadb
sudo mv /mysql_secure_installation.sql ./
sudo mysql -sfu root < "mysql_secure_installation.sql"
sudo rm -f mysql_secure_installation.sql
sudo wget -O /etc/my.cnf.d/server.cnf https://raw.githubusercontent.com/maidonghu/centos-gc/master/server.cnf
sudo systemctl restart mariadb

sudo yum install epel-release -y
sudo yum install -y redis
sudo mkdir -p /var/run/redis
sudo mv /redis.conf /etc/
sudo systemctl enable redis
echo 'vm.overcommit_memory = 1' | sudo tee -a /etc/sysctl.conf
sysctl vm.overcommit_memory=1
sudo systemctl restart redis

wget http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
sudo rpm -ivh remi-release-7.rpm
sudo yum --enablerepo=remi,remi-php71 install php php-mysqlnd php-gd php-xml php-redis php-xmlrpc php-mbstring php-mcrypt php-fpm php-opcache php-apcu -y
sudo systemctl enable php-fpm
sudo mv /www.conf /etc/php-fpm.d/
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
sudo wget -O /etc/nginx/conf.d/http.conf https://raw.githubusercontent.com/maidonghu/centos-gc/master/http.conf

cd /var/www/html/wp-content/plugins/
sudo wget https://downloads.wordpress.org/plugin/updraftplus.1.12.35.zip
sudo unzip updraftplus.1.12.35.zip
sudo mv /wp-config.php /var/www/html/
sudo mkdir -p /etc/nginx/ssl/linode.mikecloud.info
sudo mv /fullchain1.pem /etc/nginx/ssl/linode.mikecloud.info/
sudo mv /privkey1.pem /etc/nginx/ssl/linode.mikecloud.info/

sudo chown -R apache:apache /var/www/html/wp-content
sudo systemctl restart nginx
