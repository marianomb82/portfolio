FROM ubuntu:latest

#LABEL maintainer=marianomb82@gmail.com
#LABEL version=1.0
#LABEL description=Imagen de App web

COPY integrado /var/www/integrado

ENV APACHE_RUN_DIR=/var/www
ENV APACHE_PID_FILE=/var/lib/apache2/apache2.pid
ENV APACHE_RUN_USER=www-data
ENV APACHE_RUN_GROUP=www-data
ENV APACHE_LOG_DIR=/var/log/apache2

RUN apt-get -y update && \
		ln -fs /usr/share/zoneinfo/Europe/Madrid /etc/localtime && \
		DEBIAN_FRONTEND=noninteractive apt-get install -y apache2 php php-mysql php-mbstring && \
		dpkg-reconfigure --frontend noninteractive tzdata && \
		sed -i 's|DocumentRoot /var/www/html|DocumentRoot /var/www/integrado|g' /etc/apache2/sites-enabled/000-default.conf && \
		sed -i 's|ErrorLog ${APACHE_LOG_DIR}/error.log|ErrorLog /dev/stderr|g' /etc/apache2/sites-enabled/000-default.conf && \
		sed -i 's|CustomLog ${APACHE_LOG_DIR}/access.log combined|CustomLog /dev/stdout combined|g' /etc/apache2/sites-enabled/000-default.conf

EXPOSE 80

CMD ["/bin/sh" "-c" "apachectl -D FOREGROUND"]
