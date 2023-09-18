# Práctica: Contenedores, más que VMs
Full Stack DevOps Bootcamp VII

Módulo Contenedores: Más que VMs

Febrero 2023


En primer lugar se necesita instalar, si no estuviera instalado, Minikube siguiendo las instrucciones del enlace https://minikube.sigs.k8s.io/docs/start/ (hay que indicar que el proyecto se ha realizado en un entorno Ubuntu 22.04, por si se quiere seguir el mismo entorno de trabajo).

Para arrancar Minikube utilizaremos los siguientes comandos, como viene en la documentación: https://minikube.sigs.k8s.io/docs/drivers/kvm2/
```
minikube start --driver=kvm2
minikube config set driver kvm2
```
Arrancamos Minikube
```
minikube start (si estamos como sudo tendremos que ejecutar minikube start --force)
```
Podemos aportar este consejo por la gran cantidad de veces que utilizaremos el comando kubectl y consta de crear un alias para dicho comando:
Ejecutamos:
```
nano /home/marianomb82/.bashrc
```
Introducimos ```alias k='kubectl'```
Guardamos el archivo y ejecutamos ```source /home/marianomb82/.bashrc```

Los ficheros de nuestra práctica con Kubernetes deberemos bajarla del repositoriode Github, y se encuentran en la carpeta k8s.

A continuación se describirán los recuros creados y las opciones configurables:
* 0_ingress-nginx.yaml
  * Creamos los parámetros de nuestro proxy inverso para que podamos conectarnos a nuestro pod que contiene la app del tipo web desde fuera del clúster.*
* 1_service_ingress-nginx-custom.yaml
  * Creamos el tipo de servicio y los puertos por los que escuchará el servicio  
* 2_namespace_kmmb82.yaml
  * Creamos el nombre del namespace par que se desplieguen todos los pods en ese namespace indicado en los archivos de despliegue 
* configmap_bd-data.yaml
  * Creamos los datos referentes al nombre de la Base de datos y al host que la albergará.
* secret_bd-credentials.yaml
  * Creamos los datos sensibles para poder logarnos contra la Base de datos.
* statefulset_mysql.yaml
  * Creamos los parámetros con los que se desplegará nuestro pods, en este caso hacemos referencias a un volumen par darnos persistencia de datos a la hora de montar la Base de datos.
* service_mysql.yaml
  * Creamos el tipo de servicio y los puertos por los que escuchará el servicio 
* job_init-db.yaml
  * Creamos los parámetros con los que cargará la Base de datos de nuestra aplicación una vez levantado el pod de MySQL y el servidio de MySQL.
* deploy_apache.yaml
  * Creamos los parámetros con los que se desplegarán las réplicas de nuestro pods, en este caso hacemos referencias a las variables que nos harán falta para que funcione el código en HPH al a hora de conectar con la base de datos de nuestra aplicación.
* service_apache.yaml
  * Creamos el tipo de servicio y los puertos por los que escuchará el servicio 
* ingress_apache.yaml
  * Creamos los parámetros del proxy inverso para que podamos conectarnos a nuestro pod apache que contiene la app del tipo web desde fuera del clúster.
* hpa_apache.yaml
  * Creamos los parámetros de la alta disponibilidad de nuestro pod de apache indicando réplicas mínimas, másximas y cuando deben de replicarse.

Para lanzar las imágenes en Kubernetes lo realizaremos en el siguiente orden para garantizar que todo levanta correctamente, aunque salvo las 2 primeras que son las más críticas, el resto las podríamos lanzar todas a la vez, con los siguientes comandos:

# Despliegue del Ingress
```
k apply -f 0_ingress-nginx.yaml
```
# Despliegue del Namespace de las imágenes
```
k apply -f 1_namespace_kmmb82.yaml
```
# Despliegue del Configmap de la Base de datos
```
k apply -f configmap_bd-data.yaml
```
# Despliegue de los secrets de la Base de datos 
```
k apply -f secret_bd-credentials.yaml
```
# Despliegue del Statefulset de la Base de datos
```
k apply -f statefulset_mysql.yaml
```
# Despliegue del Service de la Base de datos
```
k apply -f service_mysql.yaml
```
# Despliegue del Job para cargar la Base de datos si no lo estuviera  
```
k apply -f job_init-db.yaml
```
# Despliegue del Apache
```
k apply -f deploy_apache.yaml
```
# Despliegue del Service del Apache
```
k apply -f service_apache.yaml
```
# Despliegue del Service del Ingress
```
k apply -f service_ingress-nginx-custom.yaml
```
# Despliegue del Ingress del Apache
```
k apply -f ingress_apache.yaml
```
# Despliegue del Horizontal pod autoescaler del Apache
```
k apply -f hpa_apache.yaml
```  
Podemos compobar el estado tras el despliegue ejecutando k get pods -n kmmb82 dando el resultado:
```
NAME                      READY   STATUS      RESTARTS       AGE
apache-5fc544d9fd-45zwk   0/1     Running     1 (103s ago)   26m
apache-5fc544d9fd-xqhbg   0/1     Running     1 (103s ago)   26m
apache-5fc544d9fd-zmr7v   0/1     Running     1 (103s ago)   25m
init-db-4jt65             0/1     Completed   0              30m
mysql-0                   1/1     Running     1 (111s ago)   12m
```
Se ven las 3 instancias cómo al configurar el Affiniti solo está corriendo una de las 3 instancias que tiene la imagen configurada, se puede comprobar el estado ejecutando:``` k get pods -n kmmb82```
```
NAME                      READY   STATUS      RESTARTS   AGE
apache-55f8ffc9cc-j5qvc   0/1     Pending     0          2m35s
apache-55f8ffc9cc-k49jn   0/1     Pending     0          2m36s
apache-594766cbcf-4dfxz   1/1     Running     0          18h
apache-594766cbcf-glscw   1/1     Running     0          18h
init-db-4jt65             0/1     Completed   0          19h
mysql-0                   1/1     Running     0          18h
```
Para poder sacar algo más de detalle podemos ejecutar el comando:```k events -w -n kmmb82```
```
LAST SEEN               TYPE      REASON             OBJECT                        MESSAGE
3m17s (x2 over 4m20s)   Warning   FailedScheduling   Pod/apache-55f8ffc9cc-j5qvc   0/1 nodes are available: 1 node(s) didn't match pod anti-affinity rules. preemption: 0/1 nodes are available: 1 No preemption victims found for incoming pod..
3m17s (x2 over 4m21s)   Warning   FailedScheduling   Pod/apache-55f8ffc9cc-k49jn   0/1 nodes are available: 1 node(s) didn't match pod anti-affinity rules. preemption: 0/1 nodes are available: 1 No preemption victims found for incoming pod..
4m21s                   Normal    SuccessfulCreate   ReplicaSet/apache-55f8ffc9cc   Created pod: apache-55f8ffc9cc-k49jn
4m20s                   Normal    SuccessfulCreate   ReplicaSet/apache-55f8ffc9cc   Created pod: apache-55f8ffc9cc-j5qvc
4m21s                   Normal    Killing            Pod/apache-594766cbcf-67274    Stopping container apache
4m21s                   Normal    SuccessfulDelete   ReplicaSet/apache-594766cbcf   Deleted pod: apache-594766cbcf-67274
4m22s                   Normal    ScalingReplicaSet   Deployment/apache              Scaled up replica set apache-55f8ffc9cc to 1
4m21s                   Normal    ScalingReplicaSet   Deployment/apache              Scaled down replica set apache-594766cbcf to 2 from 3
4m20s                   Normal    ScalingReplicaSet   Deployment/apache              Scaled up replica set apache-55f8ffc9cc to 2 from 1
```

Para comprobar todos los recursos generados y sus estados dentro de nuestro namespace ejecutamos: ```k get all -n kmmb82```
```
NAME                          READY   STATUS      RESTARTS   AGE
pod/apache-55f8ffc9cc-j5qvc   0/1     Pending     0          5h18m
pod/apache-55f8ffc9cc-k49jn   0/1     Pending     0          5h18m
pod/apache-594766cbcf-4dfxz   1/1     Running     0          23h
pod/apache-594766cbcf-glscw   1/1     Running     0          23h
pod/init-db-4jt65             0/1     Completed   0          24h
pod/mysql-0                   1/1     Running     0          23h

NAME             TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
service/apache   ClusterIP   10.104.188.122   <none>        80/TCP     24h
service/mysql    ClusterIP   10.99.189.208    <none>        3306/TCP   24h

NAME                     READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/apache   2/3     2            2           25h

NAME                                DESIRED   CURRENT   READY   AGE
replicaset.apps/apache-55f8ffc9cc   2         2         0       5h18m
replicaset.apps/apache-594766cbcf   2         2         2       23h
replicaset.apps/apache-5f884d44b6   0         0         0       25h
replicaset.apps/apache-5fc544d9fd   0         0         0       24h
replicaset.apps/apache-66b946956f   0         0         0       23h

NAME                     READY   AGE
statefulset.apps/mysql   1/1     25h

NAME                                         REFERENCE           TARGETS         MINPODS   MAXPODS   REPLICAS   AGE
horizontalpodautoscaler.autoscaling/apache   Deployment/apache   <unknown>/70%   2         20        3          3h43m

NAME                COMPLETIONS   DURATION   AGE
job.batch/init-db   1/1           6s         24h
```
Para comprobar la ip de nuestro nodo lanzamos:
```
k get nodes -o wide
NAME       STATUS   ROLES           AGE   VERSION   INTERNAL-IP     EXTERNAL-IP   OS-IMAGE               KERNEL-VERSION   CONTAINER-RUNTIME
minikube   Ready    control-plane   43h   v1.26.1   192.168.39.12   <none>        Buildroot 2021.02.12   5.10.57          docker://20.10.23
```

Una vez comprobado que todo funciona correctamente debemos insertar en el fichero /etc/hosts la Ip que nos muestra al ejecutar: y el nombre del servidor quedando algo parecido a esto:
```
192.168.39.12	apache.marianomb82.com
```

Para logarnos en la parte de gestión de nuestra App hay que logarse con el usuario mariano y contraseña Mariano1, siempre se puede introducir en el fichero de carga de la base de datos un usuario si fuera necesario. 


## Keepcoding
Autor: 
Mariano Martín Bugarín <marianomb82@gmail.com>
