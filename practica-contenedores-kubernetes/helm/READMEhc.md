# Práctica: Contenedores, más que VMs
Full Stack DevOps Bootcamp VII

Módulo Contenedores: Más que VMs

Febrero 2023

Vamos a comentar la principal funcionalidad del uso de Helm Chart, facilitar la flexibilidad de cambios en los recursos que tenemos en nuestro fichero values.yaml
Tenemos la posibilidad de cambiar en todos los ficheros de nuestros recursos:
* El namespace de nuestro entorno de trabajo.
```
namespace: hmmb82
```
* Los datos de conexión de la base de datos codificado en base64.
```
connection:
  data:
    MYSQL_PASSWORD: MTIzNA==
    MYSQL_ROOT_PASSWORD: MTIzNA==
    MYSQL_USER: Y2Rz
```
* Las características de nuesto apache, nombre, imagen, réplicas, saber si está corriendo, si puede recibir tráfico...
```
apache:
  name: apache
  image: marianomb82/mmb82-apache:v2
  imagePullPolicy: IfNotPresent
  podAntiAffinity: apache
  podAffinity: mysql
  replicas: 3
  livenessProbe:
    failureThreshold: 5
    initialDelaySeconds: 60
    periodSeconds: 5
    successThreshold: 1
    timeoutSeconds: 5
  readinessProbe:
    failureThreshold: 3
    initialDelaySeconds: 30
    periodSeconds: 5
    successThreshold: 1
    timeoutSeconds: 5  
```
* Las características de nuestro mysql, nombre e imagen.
```
mysql:
  name: mysql
  image: marianomb82/mmb82-mysql:v6
```
* Las características de nuestro init-db que carga los datos en la base de datos, nombre e imagen
```
initdb:
  name: init-db
  image: marianomb82/mmb82-init_db:v1
```
Para lanzar una vez descargado del repositorio podemos ejecutar donde esté la carpeta /helm:
```
hlem install --create-namespace --namespace hmmb82 hmmb82 ./
```
Comprobar la ip relacionada con nuestro host en helm 
```
k get ingress -n hmmb82
NAME     CLASS   HOSTS                        ADDRESS   PORTS   AGE
apache   nginx   apachehelm.marianomb82.com             80      42m

k get nodes -o wide
NAME       STATUS   ROLES           AGE   VERSION   INTERNAL-IP     EXTERNAL-IP   OS-IMAGE               KERNEL-VERSION   CONTAINER-RUNTIME
minikube   Ready    control-plane   45h   v1.26.1   192.168.39.12   <none>        Buildroot 2021.02.12   5.10.57          docker://20.10.23

```
Tenemos que introducir en el fichero hosts el nuevo dominio de nuestro sitio web a continuación del que tenemos, quedando así.
```
nano /etc/hosts
192.168.39.12	apache.marianomb82.com apachehelm.marianomb82.com
```

## Keepcoding
Autor: 
Mariano Martín Bugarín <marianomb82@gmail.com>
