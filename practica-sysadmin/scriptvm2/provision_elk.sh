#!/bin/bash

#Archivo de provisión de VM2 para particionar el disco creado, crear volúmenes, formatear y montar en la ruta establecida

#logado como root
sudo su -

#creamos la partición del disco adicional
parted -s /dev/sdc mklabel gpt mkpart primary 0% 100% set 1

#creamos el volumen lógico
pvcreate /dev/sdc1
vgcreate DATA /dev/sdc1
lvcreate -n elk -l 100%FREE DATA

#damos formato al volumen lógico
mkfs.ext4 /dev/mapper/DATA-elk

#creamos la ruta para la nueva unidad
mkdir /var/lib/elasticsearch

#insertamos en fstab la nueva unidad
echo "#montamos nueva unidad" >> /etc/fstab
echo "/dev/mapper/DATA-elk	/var/lib/elasticsearch	ext4	defaults	0	2" >> /etc/fstab

#montamos la unidad
mount -a

#Instalamos Filebeat
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-7.x.list

#damos margen con sleep porque sin el sleep en mi equipo local no le da lugar a actualizar los repositorios.
sleep 15

#actualizamos los repositorios
apt-get update

#instalamos filebeat y Logstash
apt-get install -y default-jre nginx filebeat logstash

#creamos el fichero /etc/logstash/conf.d/02-beats-input.conf e introducimos el contenido al archivo
cp /tmp/02-beats-input.conf /etc/logstash/conf.d/02-beats-input.conf

#copiar el archivo 10-syslog-filter.conf porque puede dar fallo de formato a /etc/logstash/conf.d/
cp /tmp/10-syslog-filter.conf /etc/logstash/conf.d/10-syslog-filter.conf

#creamos el fichero /etc/logstash/conf.d/30-elasticsearch-output.conf e introducimos el contenido al archivo
cp /tmp/30-elasticsearch-output.conf /etc/logstash/conf.d/30-elasticsearch-output.conf

#arrancamos el servicio logstash
systemctl enable logstash --now

#instalar paquete elasticsearch
apt-get install -y elasticsearch

#damos permisos a la ruta /var/lib/elasticsearch al usuario elasticsearch
chmod 777 /var/lib/elasticsearch

#arrancamos el servicio elasticsearch
systemctl enable elasticsearch.service --now

#instalar paquete kibana
apt-get install -y kibana

#configuramos nginx indicando, pero antes realizamos una copia del archivo original porsi..
mv /etc/nginx/sites-available/default /etc/nginx/sites-available/default.ori

echo '''# Managed by installation script - Do not change
server {
   listen 80;
   
   server_name kibana.demo.com localhost;

   auth_basic "Restricted Access";
   auth_basic_user_file /etc/nginx/htpasswd.users;

   location / {
       proxy_pass http://localhost:5601;
       proxy_http_version 1.1;
       proxy_set_header Upgrade \$http_upgrade;
       proxy_set_header Connection 'upgrade';
       proxy_set_header Host \$host;
       proxy_cache_bypass \$http_upgrade;
   }
}''' > /etc/nginx/sites-available/default

#creamos archivo con la contraseña de kibana
echo "devops7" > /vagrant/.kibana

#generamos el fichero de contraseñas
echo "kibanaadmin:$(openssl passwd -apr1 -in /vagrant/.kibana)" | sudo tee -a /etc/nginx/htpasswd.users

#arrancamos el servicio Kibana y reiniciamos nginx
systemctl enable kibana --now
systemctl restart nginx
