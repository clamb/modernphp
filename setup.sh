#!/bin/bash

# Autheur: Christophe Lambercy (christophe.lambercy@cpnv.ch)
# Date: 04.04.2017
# Description: 
#   Ce script installe les packages nécessaires pour du développement
#   web dans le cadre des cours web de la média. Il est appelé par 
#   le fichier Vagrantfile.

VAGRANTDIR=/vagrant
SERVERDIR=/var/www/modernphp
SSLCERTDIR=/etc/ssl/crt

apt-get update
apt-get install -y vim
apt-get install -y apache2
apt-get install -y libapache2-mod-php7.0
apt-get install -y mariadb-server
apt-get install -y php7.0
apt-get install -y php7.0-mysql
apt-get install -y php7.0-intl
apt-get install -y php7.0-mbstring
apt-get install -y php7.0-json
apt-get install -y php7.0-cli
apt-get install -y php7.0-xml

sudo cp $VAGRANTDIR/modernphp.local.conf /etc/apache2/sites-available/modernphp.local.conf
sudo ln -sf /etc/apache2/sites-available/modernphp.local.conf /etc/apache2/sites-enabled/modernphp.local.conf
sudo rm -rf /etc/apache2/sites-enabled/000-default.conf

echo "Creating self-signed certificate"
sudo rm -rf $SSLCERTDIR
sudo mkdir $SSLCERTDIR
sudo openssl req -x509 -nodes -days 3650 -subj '/C=CH/ST=Vaud/L=Ste-Croix/CN=modernphp.local/O=CPNV/OU=Media' -newkey rsa:2048 -keyout $SSLCERTDIR/modernphp.local.key -out $SSLCERTDIR/modernphp.local.crt

sudo ln -sf /etc/apache2/mods-available/ssl.load /etc/apache2/mods-enabled/ssl.load

# Utilise le php.ini de développement
sudo mv /etc/php/7.0/apache2/php.ini /etc/php/7.0/apache2.php.ini.bk
sudo cp /usr/lib/php/7.0/php.ini-development /etc/php/7.0/apache2/php.ini

sudo systemctl restart apache2.service

if [ ! -e $SERVERDIR ]
then
  mkdir $SERVERDIR
fi

# Mariadb stuff
# By default, mysql uses the plugin "unix_socket" for root. Therefore, you need to sudo when using mysql.
/usr/bin/mysqladmin -s -u root password 'cpnv4321' || echo "** Mot de passe probablement déjà défini **"

echo "Crée une base de données pour le web (cpnvdev)"
echo "create database if not exists cpnvdev" | mysql -u root -pcpnv4321
echo "grant all privileges on cpnvdev.* to 'cpnvdev'@'localhost' identified by 'cpnv1234' with grant option" | mysql -u root -pcpnv4321

echo "Crée un base de données pour wordpress (wp)"
echo "create database if not exists wp" | mysql -u root -pcpnv4321
echo "grant all privileges on wp.* to 'cpnvdev'@'localhost' identified by 'cpnv1234' with grant option" | mysql -u root -pcpnv4321

echo "flush privileges" | mysql -u root -pcpnv4321

