FROM ubuntu:latest

#LABEL maintainer=marianomb82@gmail.com
#LABEL version=1.0
#LABEL description=Imagen de App web

RUN apt-get update -y && \
		apt-get install mysql-client -y && \
		mkdir /script

COPY ./localhost.sql /script/
COPY ./init_db.sh /script/

RUN chmod a+x /script/init_db.sh
		
CMD ["/script/init_db.sh"]
