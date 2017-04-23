Information
===========

Modernphp est une machine virtuelle pour le développement web dans le cadre
des cours d'informatique web du CPNV.

Les logiciels suivants sont installés :

* Ubuntu 16.04
* Apache2
* MariaDB Server (dernière version au moment de l'installation)
* PHP 7.0 (avec mysql, intl, mbstring, json, cli et xml


Contenu
=======

* Readme.md : ce fichier
* Vagrantfile : le fichier de configuration de la machine virtuelle
* modernphp.local.conf : le fichier de configuration d'apache
* setup.sh : le shell bash qui est exécuté dans la VM lorsqu'elle est provisionnée 
* www/index.html : un fichier d'exemple
* www/phpinfo.php : pour obtenir les fichiers de configuration

Installation
============

1. Créer un répertoire `vagrant` sur votre disque (à la racine de `C:\\` sur Windows, dans votre home sur MacOS).
2. Copier les fichiers `Vagrantfile`, `modernphp.local.conf` et `setup.sh` dans le dossier `vagrant` créé ci-dessus
3. Ouvrez une fenêtre de terminal (ou ligne de commande) et se déplacer dans le répertoire `vagrant`
   (`cd C:\\vagrant` avec Windows, `cd ~/vagrant` avec MacOS).
4. `vagrant plugin install vagrant-auto_netword`.
5. `vagrant plugin install vagrant-hostmanager`.
6. Pour démarrer le téléchargement et l'installation de la machine virtuelle, exécuter la commande `vagrant up`.
7. Le plugin `hostmanager` permet de mettre à jour votre fichier `hosts` pour que l'adresse `modernphp.local` soit
   dirigé vers votre machine. Pour cela, exécuter la commande `vagrant hostmanager`.
8. Vérifier l'installation en vous connectant sur votre machine : `vagrant ssh`.
9. Vérifier le bon fonctionnement de la machine et des applications en ouvrant l'adresse `http://modernphp.local/index.html`
