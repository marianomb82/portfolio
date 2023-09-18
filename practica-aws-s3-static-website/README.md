# Práctica: Migración a la nube, AWS
Full Stack DevOps Bootcamp VII

Módulo Contenedores: Migración a la nube, AWS

Marzo 2023

Contenido del repositorio:
* Archivo README.md: Fichero de README con las instrucciones de la práctica del sitio web montado sobre un Bucket.
* Archivo main.tf: Fichero de Terraform con los objetos a desplegar dentro del Bucket S3.
* Archivo outputs.tf: Fichero de Terraform con las salidas del proyecto.
* Archivo providers.tf: Fichero de Terraform con la provisión del proyecto.
* Archivo variables.tf: Fichero de Terraform con las variables del proyecto.
* Archivo index.html: Fichero HTML para el sitio web al navegar en este.
* Archivo error.html: Fichero HTML para el sitio web cuando exista error en la navegación.
* Archivo different-languages.jpg: Fichero JPG cque se llama desde el archivo index.html al navegar al sitio web.
* Archivo Acceso-bloqueado.jpg: Fichero JPG cque se llama desde el archivo error.html al existir un error al navegar al sitio web.
* Archivo .gitignore: Ficheros que no hay que subir al repositorio. 

Descripción de la aplicación:
Se va a realizar despliegue de un website estático en un Bucket S3 de AWS en la zona de irlanda, generando un output de salida con el endpoint de la conexión,mediante una plantilla de Terraform.

Funcionamiento de la aplicación.
La aplicación Web desarrollada se integra en un Bucket S3 de AWS. una vez montado el Bucket se podrá aceeder a él desde el navegador devolviendo un mensaje de bienvenida, y si se accediera a un a parte no habilitada devuelve un mensaje de error de acceso denegado. Se recomienda entrar en modo incógnito para su correcto funcionamiento ya que puede quedar cacheado el sitio web y no dar el resultado deseado.

Requisitos para hacerla funcionar.

En primer lugar se necesita instalar, si no estuviera instalado, Terraform  engine siguiendo las instrucciones del enlace https://joachim8675309.medium.com/install-terraform-with-tfenv-893433f348dd , si se usan entornos Linux o Mac (Si se realiza desde Windows debemos instalar lo indicado en este enlace https://docs.chocolatey.org/en-us/choco/setup).

En segundo lugar se necesita instalar, si no estuviera instalado, AWS CLI siguiendo las instrucciones del enlace https://docs.aws.amazon.com/es_es/cli/latest/userguide/getting-started-install.html

Para poder realizar la conexión con el CLI de AWS, deberemos haber creado un usuario en IAM de AWS y tener sus credenciales, podemos exportarlas en un fichero CSV para mayor comodidad o si no lo tenemos a mano, podemos generar unas Keys nuevas.

una vez configurado el CLI de AWS debemos ubicarnos en la carpeta donde se encuentras nuestros ficheros y ejecutar los siguientes comandos:
terraform init

terraform apply

Una vez desplegado y realizadas las pruebas hay que entrar en la consola de AWS ir a S3 entrar en Buckets, entrar en nuestro Bucket, entrar en Objets y borrar los archivos que se cargaron para poder hacer funcionar el sitio web. una vez borrados ejecutaremos, para borrar el Bucket desplegado:
terraform destroy

## Keepcoding
Autor: 
Mariano Martín Bugarín <marianomb82@gmail.com>
