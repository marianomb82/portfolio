# Péctica Agile SysAdmin:Networking and Systems Administration
Full Stack DevOps Bootcamp VII

Módulo 1: SysAdmin - Administración de redes y sistemas

Enero 2023

Pasos a seguir:

1. Para poder lanzar el proyecto es necesario instalar en la máquina Virtualvox y Vagrant.
2. Abrimos la terminal y en la carpeta donde se haya clonado el repositorio ejecutamos vagrant up --provision.
3. Una vez terminado el aprovisionamieno de las máquinas se puede conectar por SSH con vagrant ssh server1/server2, desde la carpeta del repositorio.
4. Si queremos entrar en el wordpresss de las máquinas aprovisionadas podremos hacerlo con:
http://localhost:8081 --> Para acceder a la home del Wordpress.
http://localhost:8080 --> Para acceder a la home del ELK.

Contenido del repositorio:
* Archivo README.md: Fichero de README con las instrucciones del montaje.
* Archivo .gitignore: Ficheros que no hay que subir al repositorio. 
* Carpeta scriptvm1: Carpeta con el archivo de provisión de la máquina virtual 1 que tiene instalado wordpress.
* Carpeta scriptvm2: Carpeta con el archivo de provisión de la máquina virtual 2 que tiene instalado ELK y archivos de configuración necesarios.
* Carpeta evidencias: Carpeta con los pantallazos de las evidencias de que las máquinas funcionan y los aplicativos están corriendo.


## Keepcoding
Autor: 
Mariano Martín Bugarín <marianomb82@gmail.com>