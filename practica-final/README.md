<a name="main"></a>
<div align="center">

# **Paradigma Team**

## **Proyecto final DevOps & Cloud Computing Full Stack Bootcamp VII**

</div>
<br>

# **Índice de contenidos**
- [**Equipo**](#team)
- [**Descripción**](#desc)
- [**Despliegue en entorno local**](#rc_local)
- [**Despliegue en Kubernetes**](./k8s/README.md)

<br>
<a name="team"></a>

## **Equipo**

- Mariano Martín Bugarín  `@marianomb82`
- Pablo Cazallas González `@valande`
- Alejandro Moreno Compadre `@LonelyGlare`

<br>
<a name="desc"></a>

## **Descripción**
El proyecto consiste en realizar el diseño e implementación de una infraestructura ágil, definiendo un 
sistema integral para gestión de SLM y/o ALM, junto con diferentes formas posibles de despliegar el producto.  
A la hora de aplicar una metodología DevOps se ha optado por SCRUM y se ha implementado Git Flow como flujo
de trabajo, siguiendo el versionado semántico.  
Dado el corto período de tiempo disponible para el proyecto, los sprints se han fijado por semanas, y se han
hecho restrospectivas a la par de las tutorías realizadas.  
En cuanto a los componentes y servicios empleados para implementar la arquitectura mostrada, encontramos los siguientes:  
- **Jira**: Herramienta de gestión de proyectos de Atlassian que ha permitido integrar SCRUM y GitFlow junto con el repositorio de Github.
- **Git**: Sistema de control de versiones distribuído.
- **Python**: Lenguaje de programación multiparadigma, interpretado y modular.
- **FastAPI**: Framework web de Python para desarrollo de APIs de alto rendimiento.
- **Docker**: Motor de ejecución y administración de contenedores de aplicaciones, y cliente del mismo.
- **Kubernetes**: Sistema open source para la gestión, escalado y despliegue de contenedores de aplicaciones.
- **Helm**: Herramienta de instalación y gestión de despliegues en Kubernetes.
- **Terraform**: Framework de gestión de la infraestructura como código.
- **Minikube**: Aplicación que permite ejecutar un clúster de Kubernetes en una máquina local.
- **Github**: Plataforma de integración open source, utilizada como pieza central en la arquitectura.
- **Github Actions**: Pipelines de Github para CI/CD.
- **Github Packages**: Registro de Github para repositorios de contenedores de aplicaciones.
- **Docker Registry**: Registro de Docker para repositorios de contenedores de aplicaciones.
- **Google Cloud Platform**: Plataforma de servicios de computación en la nube de Google.
- **GKE**: PaaS autogestionada para despliegue de clústers de Kubernetes en GCP.
- **Slack**: Plataforma web de trabajo colaborativo con integración de aplicaciones externas.
- **Prometheus**: Sistema de recolección de métricas y envío de alertas .
- **Grafana**: Herramienta de monitorización basada en paneles altamente configurable.
- **ArgoCD**: Automatización de despliegues.
- **Sealed Secrets**: Securización de credenciales.

<br>

![img/design/Paradigma_Architecture.png](/img/design/Paradigma_Architecture.png)

<br>
<a name="rc_local"></a>

## **Despliegue en entorno local**

Ejecutar directamente la aplicación con Python:
```
$ python3 -m venv venv
$ source venv/bin/activate
$ pip install --upgrade pip
$ pip install -r requirements.txt
$ python3 ./src/app.py
```

Desplegar utilizando el script `runApp`:
```
# Con docker:
$ ./scripts/runApp.sh -c
```
```
# Con kubernetes (minikube), solo aplicación:
$ ./scripts/runApp.sh -k
```
```
# Con kubernetes (minikube), aplicación y monitorización:
$ ./scripts/runApp.sh -m
```

Eliminar despliegue realizado:
```
# Con docker:
$ ./scripts/runApp.sh -C
```
```
# Con kubernetes (minikube), solo aplicación:
$ ./scripts/runApp.sh -K
```
```
# Con kubernetes (minikube), aplicación y monitorización:
$ ./scripts/runApp.sh -M
```

<br>

Saludos, Keepcoders!

<br>

[Volver arriba](#main)
