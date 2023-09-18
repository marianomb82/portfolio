# Práctica: Ciclo de vida de un desarrollo: CI/CD
Full Stack DevOps Bootcamp VII

Ciclo de vida de un desarrollo: CI/CD

Abril 2023

Contenido del repositorio:

* Archivos gogs: Ficheros para poder ralizar los test de la app y compilarla, buscado en internet.
* Archivo Jenkisfile: Fichero de Jenkins con los stages y steps para la pipeline.
* Archivo config_pipeline.docx: Fichero donde se puede ver la configuración de la pipeline que se repita cada 30 minutos, el repositorio en el que se aloja de github,....
* Archivo docker-compose-master.yaml: Fichero de docker-compose donde se recoge la configuración del docker que hace de nodo maestro.
* Archivo docker-compose-slave.yaml: Fichero de docker-compose donde se recoge la configuración del docker que hace de nodo esclavo.
* Archivo docker-compose.yaml: Fichero de docker-compose donde se recoge la configuración de los dockers una vez que se ha ejecutado por primera vez.
* Archivo makefile: Fichero de Makefile para lanzar el proyecto en local.
* Archivo nodo_jenkins.docx: Fichero que recoge de docker-compose donde se recoge la configuración del docker que hace de nodo maestro.
* Archivo .gitignore: Ficheros que no hay que subir al repositorio. 

Descripción de la aplicación:
Se va a contruir una aplicación en golang que tiene una web para poder ejecutarla con los test en un primer lugar con un makefile en local y luego con una pipeline en jenkins, se realizarán test para ver que la aplicación está ok 

Requisitos para hacerla funcionar.
En primer lugar descargar el repositorio
Hay que ejecutar en primer lugar docker-compose-master.yaml para arrancar el primer nodo y configurar el usuario de Jenkins e introducir el token que genera en el nodo esclavo cuando se vaya a configurar, por lo que habrá que guardar el toque que aparece.
En segundo lugar docker-compose-slave.yaml copnfiguramos la url donde apunta en el archivo y el token que se facilita en el arranque del nodo master.
una vez hecho esto, siempre podemos ejecutar el docker-compose.yaml y se arrancarán los 2 nodos
Para compilar la aplicación necesitamos ejecutar el makefile en local.
Para poder crear el pipeline en jenkins tenemos el fichero jenkins que contiene la configuración de la pipeline
Para configurar la pipeline con los parámetros de que se ejecute cada 30 minutos, el repositorio del que se tiene que alimentar... hay que fijarse en la configuración del fichero config_pipeline.docx

## Keepcoding
Autor: 
Mariano Martín Bugarín <marianomb82@gmail.com>
