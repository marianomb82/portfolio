# Práctica: Contenedores, más que VMs
Full Stack DevOps Bootcamp VII

Módulo Contenedores: Más que VMs

Febrero 2023

Contenido del repositorio:
* Archivo README.md: Fichero de README con las instrucciones de la práctica de la parte de Dockers.
* Archivo READMEK8S.md: Fichero de README con las instrucciones de la práctica de la parte de Kubernetes.
* Archivo .gitignore: Ficheros que no hay que subir al repositorio. 
* Carpeta docker-images : Carpeta donde se encuentran las carpetas de los 3 contenedores del proyecto.
*	Carpeta mmb82-apache: Contiene el fichero Dockerfile para desplegar el docker con el Apache y el código de la aplicación.
*Habrá que descomprimir una vez descargado del repositorio la carpeta mmb82-apache, el archivo integrado, que Github no deja subir tantos archivos, por eso el motivo de subirlo así.
*	Carpeta mmb82-mysql: Contiene el fichero Dockerfile para desplegar el docker con el la base de datos MySQL.
*	Carpeta mmb82_init-db: Contiene el fichero Dockerfile para desplegar el docker con de la carga de la Base de datos para que pueda funcionar la aplicación.
* Carpeta k8s: Carpeta donde se encuentran los archivos de configuración de Kubernetes del proyecto.
* docker-compose.yaml: Archivo de configuración del servicio default de la cuarta parte de la práctica, basado en los datos generados en la segunda parte de la práctica.

Descripción de la aplicación:
Se va a realizar el montaje de una aplicación en PHP con una base de datos en MySQL, que es el proyecto que desarrollé 2011 en para el fin de CFGS de ASI.
Se han tenido que adaptar ciertas partes de este proyecto realizado en 2011 para que pudiera correr en dockers basados en ubuntu y con php 8.0.
El proyecto trata de una web de un centro deportivo que contiene una parte que se accede mediante login, para la gestión interna de dicho centro deportivo. Ello dará lugar a la posibillidad de gestionar por parte de los responsables del centro deportivo desde alta de usuarios administradores, clientes, clases a impartir, etc..

Funcionamiento de la aplicación.
La aplicación Web desarrollada en PHP se integra en un Docker con Apache para oder hacer funcionar la web. Esta web interacciona con una base de datos que se integra en otro Docker con el que la base de datos y la web puedan consultar, insertar, modificar, listar y eliminar datos de la Base de datos desde la aplicación web.

Requisitos para hacerla funcionar.

En primer lugar se necesita instalar, si no estuviera instalado, Docker engine siguiendo las instrucciones del enlace https://docs.docker.com/engine/install/ (hay que indicar que el proyecto se ha realizado en un entorno Ubuntu 22.04, por si se quiere seguir el mismo entorno de trabajo).
En segundo lugar se necesita instalar, si no estuviera instalado, Docker compose siguiendo las instrucciones del enlace https://docs.docker.com/compose/install/ 
Para poder desplegar los Dockers necesitaremos, a continuación de los pasos anteriores, descargar el contendido de la carpeta docker-images del repositorio de GitHub. Estos ficheros permitirán desplegar la Aplicación mediante Docker y en segundo lugar con Docker Compose.
Las imágenes construidas, tras comprobación de que todo estaba funcionando correctamente se encuentran también subidas en el repositorio de Dockerhub marianomb82. https://hub.docker.com/u/marianomb82, desde esta ubicación se podrán utilizar para la sigueinte fase de la práctica (Kubernete-Helm Chart).

Para desplegar los contenedores, nos ubicamos en la carpeta docker-images y ejecutamos: docker compose up
```
[+] Running 3/3
 ⠿ Container practica-mysql-1        Running                                                                    0.0s
 ⠿ Container practica-apache-1       Running                                                                    0.0s
 ⠿ Container practica-mysql-setup-1  Recreated                                                                  4.5s
Attaching to practica-apache-1, practica-mysql-1, practica-mysql-setup-1
practica-mysql-setup-1  | mysql: [Warning] Using a password on the command line interface can be insecure.
practica-mysql-setup-1  | xMYSQL_UP=0
practica-mysql-setup-1  | xCOMPLETED=true
practica-mysql-setup-1  | mysql: [Warning] Using a password on the command line interface can be insecure.
practica-mysql-setup-1 exited with code 0
practica-apache-1       | 172.18.0.1 - - [26/Feb/2023:00:54:57 +0100] "GET / HTTP/1.1" 200 1986 "-" "Mozilla/5.0 (X11; Linux x86_64; rv:103.0) Gecko/20100101 Firefox/103.0"
```

Para logarnos en la parte de gestión de nuestra App hay que logarse con el usuario mariano y contraseña Mariano1, siempre se puede introducir en el fichero de carga de la base de datos un usuario si fuera necesario. 

## Keepcoding
Autor: 
Mariano Martín Bugarín <marianomb82@gmail.com>
