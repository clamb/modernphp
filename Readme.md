Information
===========

Modernphp est une machine virtuelle pour le développement web dans le cadre
des cours d'informatique web de la filière média du CPNV.

Les logiciels suivants sont installés :

* Ubuntu 16.04
* Apache2
* MariaDB Server (dernière version au moment de l'installation) * PHP 7.0 (avec mysql, intl, mbstring, json, cli et xml) 

De plus, un certificat auto-signé est généré automatiquement lors du 
provisionnement de la machine.

Base de données
===============

Deux bases de données sont créées :

* `cpnvdev` -> pour le développement web.
* `wp` -> pour Wordpress si vous deviez en avoir besoin.

L'utilisateur `cpnvdev/cpnv1234` dispose de tous les droits sur ces deux bases de données.

Si vous souhaitez vous connecter à la base de données en `root/cpnv4321`, vous devez le faire directement
depuis la machine en utilisant la commande `sudo` : 

1. `vagrant ssh`
2. `sudo mysql -u root -pcpnv4321`

Ceci car le plugin `unix_socket` est installé, ce qui oblige `root` de se connecter avec une session `root`,
rendant `sudo` obligatoire.

Contenu
=======

* `Readme.md` : ce fichier
* `Vagrantfile` : le fichier de configuration de la machine virtuelle
* `modernphp.local.conf` : le fichier de configuration d'apache
* `setup.sh` : le shell bash qui est exécuté dans la VM lorsqu'elle est provisionnée
* `www/index.html` : un fichier d'exemple
* `www/info.php` : pour obtenir les fichiers de configuration
* `sequel_pro_modernphp.plist` : pour vous connecter sur les bases de données avec Sequel Pro (Mac OS)

Installation
============

1. Créer un répertoire `vagrant` sur votre disque (à la racine de `C:\\` sur Windows, dans votre home sur MacOS).
2. Ouvrez une fenêtre de terminal (ou ligne de commande) et se déplacer dans le répertoire `vagrant`
   (`cd C:\\vagrant` avec Windows, `cd ~/vagrant` avec MacOS).
3. Exécutez la commande `git clone https://github.com/media-cpnv-ch/modernphp`
4. Déplacez-vous dans le dossier modernphp `cd modernphp`
5. Installez les plugin `auto_network` et `hostmanager` :
      1. `vagrant plugin install vagrant-auto_network`
      2. `vagrant plugin install vagrant-hostmanager`
6. Le plugin `hostmanager` permet de mettre à jour votre fichier `hosts` pour que l'adresse `modernphp.local` soit
   dirigé vers la machine virtuelle. Pour cela, exécuter la commande `vagrant hostmanager`.
7. Pour démarrer le téléchargement et l'installation de la machine virtuelle, exécuter la commande `vagrant up`.
8. Vérifier l'installation en vous connectant sur votre machine : `vagrant ssh`.
9. Vérifier le bon fonctionnement de la machine et des applications en ouvrant l'adresse `http://modernphp.local`
   ou `https://modernphp.local`
