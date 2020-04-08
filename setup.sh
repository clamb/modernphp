#!/bin/bash

# Auteur: Christophe Lambercy (christophe.lambercy@arcaciel.ch)
# Date: 04.04.2017
# Description:
#   Ce script installe les packages nécessaires pour du développement
#   web il est appelé par le VagrantFile.

VAGRANTDIR=/vagrant
SERVERDIR=/var/www/modernphp
SSLCERTDIR=/etc/ssl/crt

# Required for older php version
add-apt-repository -y ppa:ondrej/php

apt-get update
apt-get upgrade -y
apt-get install -y vim
apt-get install -y apache2
apt-get install -y libapache2-mod-php7.3
apt-get install -y mariadb-server
apt-get install -y php7.3
apt-get install -y php7.3-mysql
apt-get install -y php7.3-intl
apt-get install -y php7.3-mbstring
apt-get install -y php7.3-json
apt-get install -y php7.3-cli
apt-get install -y php7.3-xml
apt-get install -y php7.3-gd
apt-get install -y php7.3-curl

# Some cleanup
apt autoremove -y

sudo cp $VAGRANTDIR/modernphp.local.conf /etc/apache2/sites-available/modernphp.local.conf
sudo ln -sf /etc/apache2/sites-available/modernphp.local.conf /etc/apache2/sites-enabled/modernphp.local.conf
sudo rm -rf /etc/apache2/sites-enabled/000-default.conf

echo "Creating self-signed certificate"
sudo rm -rf $SSLCERTDIR
sudo mkdir $SSLCERTDIR
sudo openssl req -x509 -nodes -days 3650 -subj '/C=CH/ST=Vaud/L=Orbe/CN=modernphp.local/O=Arcaciel/OU=Dev' -newkey rsa:2048 -keyout $SSLCERTDIR/modernphp.local.key -out $SSLCERTDIR/modernphp.local.crt

sudo ln -sf /etc/apache2/mods-available/ssl.load /etc/apache2/mods-enabled/ssl.load

# Configure mysql en mode traditionel (plus strict)
sudo cp $VAGRANTDIR/mysql.cnf /etc/mysql/conf.d/mysql.cnf

# Pour que les permaliens fonctionnent avec Wordpress
sudo ln -sf /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled/rewrite.load

# Utilise le php.ini de développement
sudo mv /etc/php/7.3/apache2/php.ini /etc/php/7.3/apache2.php.ini.bk
sudo cp /usr/lib/php/7.3/php.ini-development /etc/php/7.3/apache2/php.ini

sudo systemctl restart apache2.service

if [ ! -e $SERVERDIR ]
then
  mkdir $SERVERDIR
fi

# Mariadb stuff
# By default, mysql uses the plugin "unix_socket" for root. Therefore, you need to sudo when using mysql.
/usr/bin/mysqladmin -s -u root password 'php4321' || echo "** Mot de passe probablement déjà défini **"

echo "Crée une base de données pour le web (phpdev)"
echo "create database if not exists phpdev" | mysql -u root -pphp4321
echo "grant all privileges on phpdev.* to 'phpdev'@'localhost' identified by 'php1234' with grant option" | mysql -u root -pphp4321

echo "Crée un base de données pour wordpress (wp)"
echo "create database if not exists wp" | mysql -u root -pphp4321
echo "grant all privileges on wp.* to 'phpdev'@'localhost' identified by 'php1234' with grant option" | mysql -u root -pphp4321

echo "flush privileges" | mysql -u root -pphp4321

# Add the user vagrant to the adm group so that it can read logs
adduser vagrant adm
