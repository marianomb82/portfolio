#!/bin/bash

#Archivo de provisión de VM1 para particionar el disco creado, crear volúmenes, formatear y montar en la ruta establecida

#logado como root
sudo su -

#creamos la partición del disco adicional
parted -s /dev/sdc mklabel gpt mkpart primary 0% 100% set 1

#creamos el volumen lógico
pvcreate /dev/sdc1
vgcreate DATA /dev/sdc1
lvcreate -n mariadb -l 100%FREE DATA

#damos formato al volumen lógico
mkfs.ext4 /dev/mapper/DATA-mariadb

#creamos la ruta para la nueva unidad
mkdir /var/lib/mysql 2 > /dev/null

#insertamos en fstab la nueva unidad
echo "#montamos nueva unidad" >> /etc/fstab
echo "/dev/mapper/DATA-mariadb	/var/lib/mysql	ext4	defaults	0	2" >> /etc/fstab

#montamos la unidad
mount -a

#damos margen con sleep porque sin el sleep en mi equipo local no le da lugar a actualizar los repositorios.
sleep 5

#actualizamos los repositorios
apt-get update

#Instalamos todos los paquetes necesarios
apt-get install -y nginx mariadb-server php-fpm php-mysql expect php-curl php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip

#creamos el archivo de configuracion /etc/nginx/sites-available/wordpress
touch /etc/nginx/sites-available/wordpress

#copiamos el archivo de configuración para wordpress
echo '''# Managed by installation script - Do not change 
server { 
      listen 80; 
      root /var/www/wordpress; 
      index index.php index.html index.htm index.nginx-debian.html; 
      server_name localhost; 

      location / { 
              try_files $uri $uri/ =404;
      } 

      location ~ \.php$ {
              include snippets/fastcgi-php.conf; 
              fastcgi_pass unix:/var/run/php/php8.1-fpm.sock; 
      } 

      location ~ /\.ht { 
              deny all; 
      } 
 }''' > /etc/nginx/sites-available/wordpress

#creamos enlace simbólico, borramos el archivo por defecto y reiniciamos el servicio para que aplique los cambios
ln -s /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled
rm /etc/nginx/sites-enabled/default
systemctl restart nginx

#securizamos la BBDD
mysql -h localhost -e "UPDATE mysql.user SET Password=PASSWORD('${db_root_password}') WHERE User='root';"
mysql -h localhost -e "DELETE FROM mysql.user WHERE User='';"
mysql -h localhost -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
mysql -h localhost -e "DROP DATABASE IF EXISTS test;"
mysql -h localhost -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';"
mysql -h localhost -e "FLUSH PRIVILEGES;"


#cargamos la configuración de la base de datos desde archivo .sql
mysql -h localhost -e "CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
mysql -h localhost -e "GRANT ALL ON wordpress.* TO 'wordpressuser'@'localhost' IDENTIFIED BY 'keepcoding';"
mysql -h localhost -e "FLUSH PRIVILEGES;"

#descargamos la release de wordpress
curl https://wordpress.org/latest.tar.gz -o /tmp/wordpress.tar.gz

#descomprimimos la release de wordpress
tar -zxf /tmp/wordpress.tar.gz -C /tmp/

#movemos la release descomprimida a la ruta especificada
mv /tmp/wordpress /var/www/

#configuramos la conexión la la BBDD
cp /var/www/wordpress/wp-config-sample.php /var/www/wordpress/wp-config.php
sed -i "s/username_here/wordpressuser/g" /var/www/wordpress/wp-config.php
sed -i "s/password_here/keepcoding/g" /var/www/wordpress/wp-config.php
sed -i "s/database_name_here/wordpress/g" /var/www/wordpress/wp-config.php

#asignamos permisos al usuario y grupo www-data
chown www-data:www-data -R /var/www/

#instalación de Filebeat
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-7.x.list

#actualizamos los repositorios
apt-get update

#instalamos filebeat
apt-get install -y filebeat

#habilitamos los módulos de filebeat
filebeat modules enable system
filebeat modules enable nginx

#configuramos filebeat indicando los ficheros logs, pero antes realizamos una copia del archivo original porsi..
mv /etc/filebeat/filebeat.yml /etc/filebeat/filebeat.yml.ori

#insertamos configuración del archivo de configuración de filebeat
echo '''
filebeat.inputs:
- type: log
  enabled: true
  paths:
    - /var/log/*.log
    - /var/log/nginx/*.log
    - /var/log/mysql/*.log

output.logstash:
  hosts: ["192.168.10.22:5044"]
''' > /etc/filebeat/filebeat.yml

#arrancamos el servicio filebeat y no habilitamos ya por defecto en el arranque de la máquina
systemctl enable filebeat --now

