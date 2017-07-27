#!/bin/bash -v

## install needed packages:
sudo yum update -y > /tmp/initfile.log

sudo yum install -y php70 php70-cli php70-common php70-gd php70-intl php70-mbstring php70-mcrypt php70-mysqlnd php70-pdo php70-pecl-igbinary php70-pecl-redis php70-process php70-pspell php70-snmp php70-soap php70-xml php70-xmlrpc php70-zip php70-opcache httpd24 mysql56 git >> /tmp/initfile.log

sudo chkconfig httpd on

## TODO: add steps to opimize php and apache

#sudo service httpd start

## Setup proper file and folder permissions
sudo groupadd www

sudo usermod -a -G www ec2-user

sudo usermod -a -G apache ec2-user

sudo usermod -a -G www apache

sudo chown -R ec2-user /var/www

sudo chgrp -R apache /var/www

sudo chmod 2775 /var/www

## Download and install composer globally
sudo php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
sudo php -r "if (hash_file('SHA384', 'composer-setup.php') === '669656bab3166a7aff8a7506b8cb2d1c292f042046c5a994c43155c0be6190fa0355160742ab2e1c88d40d5be660b410') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
sudo php composer-setup.php
sudo php -r "unlink('composer-setup.php');"
sudo mv composer.phar /usr/local/bin/composer
