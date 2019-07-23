# BASED ON MARTIN CECH'S SCRIPT

# MUNKI REPO
sudo apt-get update
sudo apt-get upgrade
sudo apt-get -y install
sudo apt-get -y install git curl build-essential apache2 apache2-utils samba

sudo rm -rf /var/www/*
cd /var/www

sudo addgroup --system munki
sudo mkdir catalogs client_resources icons manifests pkgs pkgsinfo

sudo addgroup --system munki
sudo adduser --system munki --ingroup munki
sudo usermod -a -G munki $USER
sudo usermod -a -G munki www-data
sudo chown -R $USER:munki /var/www
sudo chmod -R 2774 /var/www

# Docker
cd /usr/local
sudo mkdir docker
cd docker
# sudo mkdir nbi
# cd nbi
# sudo mkdir Packages Workflow Scripts Master Files
# cd Master
# sudo mkdir HFS NTFS NBI

# sudo addgroup --system imagr
# sudo adduser --system imagr --ingroup imagr
# sudo usermod -a -G imagr $USER
# sudo usermod -a -G imagr www-data
# sudo chown -R $USER:imagr /usr/local/docker/nbi
# sudo chmod 2774 /usr/local/docker/nbi

#munki_repo
sudo nano /etc/apache2/sites-enabled/000-default.conf
# port 80 changed to 90
<VirtualHost *:90>
        DocumentRoot /var/www/
        Alias /catalogs/ /var/www/catalogs/
        Alias /manifests/ /var/www/manifests/
        Alias /pkgs/ /var/www/pkgs/
        Alias /icons/ /var/www/icons/
        Alias /client_resources/ /var/www/client_resources/
        <Directory />
            Options FollowSymLinks
            AllowOverride None
        </Directory>
        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>

#munki_repo/margarita/reposado
sudo nano /etc/apache2/ports.conf
Listen 90 #munki_repo apache
Listen 8088 #reposado apache
Listen 8089 #margarita gui

#samba munki_repo
# sudo smbpasswd -a imagr
sudo smbpasswd -a munki

sudo nano /etc/samba/smb.conf
# add at the end

echo "[munki_repo]
path = /var/www
available = yes
valid users = munki
read only = no
browseable = yes
public = no
writable = yes" >> /etc/samba/smb.conf

# echo "[imagr_nbi_xxxx]
# path = /usr/local/docker/nbi
# available = yes
# valid users = imagr
# read only = no
# browseable = yes
# public = no
# writable = yes" >> /etc/samba/smb.conf

sudo service apache2 restart
sudo service smbd restart

# test smb://x.x.x.x/munki_repo smb://x.x.x.x/imagr_nbi_xxx/
# test x.x.x.x:90

# IMAGR Deployment
sudo apt-get install docker.io

sudo groupadd docker
sudo gpasswd -a ${USER} docker
sudo service docker restart
newgrp docker

sudo nano /usr/local/docker/startup.sh

#!/bin/bash

docker pull macadmins/tftpd
docker pull macadmins/netboot-httpd
docker pull bruienne/bsdpy:1.0
# docker pull macadmins/bsdpy
docker pull grahamgilbert/bsdpy
docker pull grahamgilbert/imagr-server
docker pull grahamgilbert/postgres

# Other stuff is above here
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)

# Other stuff is above here
chmod -R 777 /usr/local/docker/nbi
IP=`ifconfig ens160 2>/dev/null|awk '/inet addr:/ {print $2}'|sed 's/addr://'`
echo $IP

docker run -d \
	-v /usr/local/docker/nbi:/nbi \
	--name web \
	--restart=always \
	-p 0.0.0.0:80:80 \
	macadmins/netboot-httpd

docker run -d \
	-p 0.0.0.0:69:69/udp \
	-v /usr/local/docker/nbi:/nbi \
	--name tftpd \
	--restart=always \
	macadmins/tftpd

docker run -d \
	-p 0.0.0.0:67:67/udp \
	-v /usr/local/docker/nbi:/nbi \
	-e BSDPY_IFACE=eth0 \
	-e BSDPY_NBI_URL=http://$IP \
	-e BSDPY_IP=$IP \
	--name bsdpy \
	--restart=always \
	bruienne/bsdpy:1.0

sudo chmod 755 /usr/local/docker/startup.sh
sudo ./startup.sh

#MunkiReportPHP in Docker
docker run
-d -p 80:80
-e DB_NAME=munkireport
-e DB_USER=admin
-e DB_PASS=admin
-e DB_SERVER=mysql.test.internal
-e MR_SITENAME=MunkiReport-MyCompany
-e MR_TIMEZONE=Australia/Sydney
--name munkireport_webapp hunty1/munkireport-docker

docker run --name mr-mysql \
	-v /usr/local/docker/mr-mysql:/var/lib/mysql \
	-e MYSQL_ROOT_PASSWORD=testpwdadmin \
	-e MYSQL_DATABASE=munkireport \
	-e MYSQL_USER=munkireport \
	-e MYSQL_PASSWORD=testpwd \
	-d mysql

# very old
docker run -d --name munkireport \
	-p 80:80 \
	--link mr-mysql:mysql \
	-e MR_SITENAME="TrendPH" \
	-e MR_MODULES="array('munkireport','diskinfo','timemachine')" \
	michaelholttech/docker-munkireport:wip

# no authentication
docker run -d --name munkireport \
	-p 80:80 \
	--link mr-mysql:mysql \
	-e SITENAME="TrendPH" \
	-e MODULES="ard, bluetooth, disk_report, munkireport, managedinstalls, munkiinfo, network, security, warranty, timemachine, backup2go, crashplan, wifi, displays_info, applications, directory_service, filevault_status, installhistory, localadmin, mdm_status, network, network_shares, power, printer, profile, machine, event, munki_facts, softwareupdate, user_sessions, findmymac" \
	munkireport/munkireport-php:4.1.0


# docker run -d --name munkireport \
# 	-p 82:8002 \
# 	--link mr-mysql:mysql \
# 	-e MR_SITENAME="TrendPH" \
# 	-e MR_MODULES="array('munkireport','diskinfo','timemachine')" \
# 	michaelholttech/docker-munkireport:wip

# docker run -d --name munkireport \
#     -p 0.0.0.0:8002:8002 \
#     --link mr-mysql:mysql \
#     -e MR_SITENAME="TrendPH" \
#     -e MR_MODULES="array('munkireport','diskinfo','timemachine')" \
#     michaelholttech/docker-munkireport:wip

#Imagr
docker run -d --name="postgres-imagr" \
	-v /db:/var/lib/postgresql/data2 \
	-e DB_NAME=imagr_cn \
	-e DB_USER=admin \
	-e DB_PASS=tre3#!# \
	--restart="always" \
	grahamgilbert/postgres

docker run -d --name="imagr" \
	-p 81:8000 \
	--link postgres-imagr:db \
	-e ADMIN_PASS=tre3#!# \
	-e DB_NAME=imagr_cn \
	-e DB_USER=admin \
	-e DB_PASS=tre3#!#	\
	--restart="always" \
	grahamgilbert/imagr-server

#edit container - find the munkireport in www folder and add auth_config to config.php
docker exec -i -t munkireport bash

cd /www/munkireport/config.php


#create install PKG for munkireport (Unix)
bash -c "$(curl http://example.com/index.php?install)" bash -i ~/Desktop


#REPOSADO + MARGARITA GUI
sudo apt-get -y install apache2-utils libapache2-mod-wsgi python-setuptools python curl python-pip apache2
sudo easy_install flask
#18.04
sudo python /usr/lib/python2.7/dist-packages/easy_install.py flask

sudo mkdir /usr/local/asus
ln -s /usr/local/asus ~/
cd /usr/local/asus
sudo chown $USER:$USER .
git clone https://github.com/wdas/reposado.git
git clone https://github.com/jessepeterson/margarita.git
mkdir www meta

./reposado/code/repoutil --configure
# Filesystem path to store replicated catalogs and updates [None]: /usr/local/asus/www
# Filesystem path to store Reposado metadata [None]: /usr/local/asus/meta

sudo ./reposado/code/repo_sync

ln -s /usr/local/asus/reposado/code/reposadolib margarita/reposadolib
ln -s /usr/local/asus/reposado/code/preferences.plist margarita/preferences.plist

# test
python margarita/margarita.py
# * Running on http://0.0.0.0:8089 (Press CTRL+C to quit)

sudo nano /usr/local/asus/margarita/margarita.wsgi
#add

import sys
EXTRA_DIR = "/usr/local/asus/margarita"
if EXTRA_DIR not in sys.path:
	sys.path.append(EXTRA_DIR)
	
from margarita import app as application


sudo chown -R www-data:www-data /usr/local/asus
sudo chmod -R g+r /usr/local/asus

sudo a2enmod rewrite
sudo service apache2 restart
# sudo nano /etc/apache2/ports.conf
#Listen 8088
#Listen 8089

sudo nano /etc/apache2/sites-enabled/reposado.conf
# add
<VirtualHost *:8088>
	ServerAdmin webmaster@localhost
	DocumentRoot /usr/local/asus/www
	
	Alias /content /usr/local/asus/www/content
	<Directory />
		Options Indexes FollowSymLinks MultiViews
		AllowOverride All
		Require all granted
	</Directory>
	
	# Logging
	ErrorLog ${APACHE_LOG_DIR}/asus-error.log
	LogLevel warn
	CustomLog ${APACHE_LOG_DIR}/asus-access.log combined
</VirtualHost>

sudo nano /etc/apache2/sites-enabled/margarita.conf
# add
<VirtualHost *:8089>
	ServerAdmin webmaster@localhost
	DocumentRoot /usr/local/asus/www
	
	# Base configuration
	<Directory />
		Options FollowSymLinks
		AllowOverride None
	</Directory>
	
	# Margarita
	Alias /static /usr/local/asus/margarita/static
	WSGIDaemonProcess margarita home=/usr/local/asus/margarita user=www-data group=www-data threads=5
	WSGIScriptAlias / /usr/local/asus/margarita/margarita.wsgi
	<Directory />
		WSGIProcessGroup margarita
		WSGIApplicationGroup %{GLOBAL}
		Require all granted
	</Directory>
	
	# Logging
	ErrorLog ${APACHE_LOG_DIR}/asus-error.log
	LogLevel warn
	CustomLog ${APACHE_LOG_DIR}/asus-access.log combined
</VirtualHost>

sudo nano /etc/apache2/apache2.conf
#add
<Directory /usr/local/asus/www/>
		Options Indexes FollowSymLinks
		AllowOverride None
		Require all granted
</Directory>

sudo nano /usr/local/asus/www/.htaccess
#add
RewriteEngine On
Options FollowSymLinks
RewriteBase  /
RewriteCond %{HTTP_USER_AGENT} Darwin/8
RewriteRule ^index(.*)\.sucatalog$ content/catalogs/index$1.sucatalog [L]
RewriteCond %{HTTP_USER_AGENT} Darwin/9
RewriteRule ^index(.*)\.sucatalog$ content/catalogs/others/index-leopard.merged-1$1.sucatalog [L]
RewriteCond %{HTTP_USER_AGENT} Darwin/10
RewriteRule ^index(.*)\.sucatalog$ content/catalogs/others/index-leopard-snowleopard.merged-1$1.sucatalog [L]
RewriteCond %{HTTP_USER_AGENT} Darwin/11
RewriteRule ^index(.*)\.sucatalog$ content/catalogs/others/index-lion-snowleopard-leopard.merged-1$1.sucatalog [L]
RewriteCond %{HTTP_USER_AGENT} Darwin/12
RewriteRule ^index(.*)\.sucatalog$ content/catalogs/others/index-mountainlion-lion-snowleopard-leopard.merged-1$1.sucatalog [L]
RewriteCond %{HTTP_USER_AGENT} Darwin/13
RewriteRule ^index(.*)\.sucatalog$ content/catalogs/others/index-10.9-mountainlion-lion-snowleopard-leopard.merged-1$1.sucatalog [L]
RewriteCond %{HTTP_USER_AGENT} Darwin/14
RewriteRule ^index(.*)\.sucatalog$ content/catalogs/others/index-10.10-10.9-mountainlion-lion-snowleopard-leopard.merged-1$1.sucatalog [L]
RewriteCond %{HTTP_USER_AGENT} Darwin/15
RewriteRule ^index(.*)\.sucatalog$ content/catalogs/others/index-10.11-10.10-10.9-mountainlion-lion-snowleopard-leopard.merged-1$1.sucatalog [L]
RewriteCond %{HTTP_USER_AGENT} Darwin/16
RewriteRule ^index(.*)\.sucatalog$ content/catalogs/others/index-10.12-10.11-10.10-10.9-mountainlion-lion-snowleopard-leopard.merged-1$1.sucatalog [L]
RewriteCond %{HTTP_USER_AGENT} Darwin/17
RewriteRule ^index(.*)\.sucatalog$ content/catalogs/others/index-10.13-10.12-10.11-10.10-10.9-mountainlion-lion-snowleopard-leopard.merged-1$1.sucatalog [L]
RewriteCond %{HTTP_USER_AGENT} Darwin/18
RewriteRule ^index(.*)\.sucatalog$ content/catalogs/others/index-10.14-10.13-10.12-10.11-10.10-10.9-mountainlion-lion-snowleopard-leopard.merged-1$1.sucatalog [L]

sudo chown -R www-data:www-data /usr/local/asus
sudo chmod -R g+r /usr/local/asus
sudo service apache2 restart

# create cron job
sudo nano /etc/cron.daily/repo_sync
#add
#!/bin/bash
/usr/local/asus/reposado/code/repo_sync
/bin/chgrp -R www-data /usr/local/asus/www
/bin/chmod -R g+rX /usr/local/asus/www

sudo chmod +x /etc/cron.daily/repo_sync

# Credentials for Access
sudo htpasswd -c /usr/local/asus/users admin

sudo chown root.nogroup /usr/local/asus/users
sudo chmod 640 /usr/local/asus/users

sudo nano /etc/apache2/sites-enabled/margarita.conf
#add

# Authentication
<Location />
  AuthType Basic
  AuthName "Authentication Required"
  AuthUserFile "/usr/local/asus/users"
  Require valid-user
</Location>

sudo chown -R www-data:www-data /usr/local/asus
sudo chmod -R g+r /usr/local/asus

sudo service apache2 restart
