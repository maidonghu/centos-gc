#!/bin/bash
sudo yum update -y
sudo timedatectl set-timezone America/Vancouver
sudo yum install ntp -y
sudo systemctl enable ntpd
sudo systemctl start ntpd

sudo sed -i 's/#Port 22/Port 50009/' /etc/ssh/sshd_config
sudo systemctl restart sshd

sudo yum install sendmail -y
sudo systemctl enable sendmail
sudo systemctl start sendmail

echo never > /sys/kernel/mm/transparent_hugepage/enabled
echo 'echo never > /sys/kernel/mm/transparent_hugepage/enabled' | tee -a /etc/rc.local

echo 'Please logoff and login again with SSH with mike!' 
sleep 5
sudo reboot
