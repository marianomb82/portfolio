# Práctica: Liberando productos
Full Stack DevOps Bootcamp VII

Módulo Liberando productos: SRE

Abril 2023

Contenido del repositorio:
* Archivo README.md: Fichero de README con las instrucciones de la práctica.
* Archivo README_SOLUTION.md: Fichero de README con las soluciones de la práctica.
* Archivo dashboard.json: Fichero de JSON con las configuración de los 2 dashboards de grafana:
  * Número de llamadas a los endpoints.
  * Número de veces que la aplicación ha arrancado en una hora.
* Archivo Makefile: Fichero de Makefile con las instrucciones para montar las imágenes que nos harán falta para poder desplegarlas en Kubernetes.
* Archivo pytest.ini: Fichero de la aplicación suministrada para la práctica.
* Archivo requirements.txt: Fichero de conl los requerimientos suministrada para la práctica.
* Carpeta snapshots: Carpeta que contiene captura de pantalla con evidencias.
* Carpeta grafana: Carpeta que contiene la configuración del dashboard de Grafana.
* Carpeta prometheus: Carpeta que contiene la configuración del Prometheus para desplegarlo en Kubernetes.
* Carpeta simple-server: Carpeta que contiene la configuración de nuestra aplicación para poderla desplegar en Kubernetes.
* Carpeta .github/workflows: Contiene los workflow que montaremos en Github Actions, reutilizaremos los aportados en pla práctica.
* Carpeta src: Carpeta que contiene la configuración de la aplicación en Python que tenemos que modificar para adaptar los enpoint y los tests de estos.
  * Archivo app.py en /src/application donde debemos introducir lo siguiente bajo los endpoints ya creados.
    ```
    MAIN_ENDPOINT_REQUESTS_2 = Counter('main_requests_total_2', 'Total number of requests to main endpoint 2')
    MAIN_ENDPOINT_REQUESTS_3 = Counter('main_requests_total_3', 'Total number of requests to main endpoint 3')
    ```
    ```
    @app.get("/bye")
        async def read_main():
            """Implement main endpoint 2"""
            # Increment counter used for register the total number of calls in the webserver
            REQUESTS.inc()
            # Increment counter used for register the total number of calls in the main endpoint 2
            MAIN_ENDPOINT_REQUESTS_2.inc()
            return {"msg": "Bye bye"}

        @app.get("/sre")
        async def read_main():
            """Implement main endpoint 3"""
            # Increment counter used for register the total number of calls in the webserver
            REQUESTS.inc()
            # Increment counter used for register the total number of calls in the main endpoint 3
            MAIN_ENDPOINT_REQUESTS_3.inc()
            return {"msg": "Liberando productos mola"}
    ```
  * Archivo app_test.py en /src/tests donde debemos introducir lo siguiente bajo los test ya creados.
    ```
    @pytest.mark.asyncio
    async def read_main_test(self):
        """Tests the main endpoint 2"""
        response = client.get("/bye")

        assert response.status_code == 200
        assert response.json() == {"msg": "Bye bye"}
        
    @pytest.mark.asyncio
    async def read_main_test(self):
        """Tests the main endpoint 3"""
        response = client.get("/sre")

        assert response.status_code == 200
        assert response.json() == {"msg": "Liberando productos mola"} 
    ```

## Creación de helm chart para desplegar la aplicación en Kubernetes

* Construir la imagen del contenedor ejecutamos el archivo Makefile, ya que lo tenemos automatizado en dicho archivo.  
    ```
    $ make
    ```

* Arrancar minikube. 
    ```
    $ minikube start
    ```

* Crear un helm chart para desplegar la aplicación en kubernetes. Si tienes unos archivos de confianza también se pueden reutilizar cambiando los parámetros como en nuetro caso:
    ```
    $ helm create simpleserver
    ```

    Modificar los atributos del fichero `values.yaml`.  
    ```
    namespace: simpleserver
    simpleserver:
    name: simpleserver
    image: marianomb82/simple-server:0.0.2
    ```
    Modificar los atributos del fichero `deploy_simple-server.yaml`.
    ```
    httpGet:
        path: /health
        port: 8081
        scheme: HTTP
    ...
    ports:
        - name: api
          containerPort: 8081
          protocol: TCP
        - name: metrics
          containerPort: 8000
          protocol: TCP
    ```

    Modificar el atributo `appVersion` del fichero `Chart.yaml`.  

    ```
    appVersion: 0.0.2
    ```
    
    Desplegar el chart de nuestro simple server:
    ```
    $ helm install simpleserver simple-server/ -f simple-server/values.yaml --namespace simpleserver --create-namespace
    ```

    Desplegar el chart de nuestro Prometheus::
    ```
    $ helm install kube-prometheus-stack prometheus-community/kube-prometheus-stack -f prometheus/values.yaml --namespace monitoring --create-namespace

    NAME: kube-prometheus-stack
    LAST DEPLOYED: Sun Apr 30 16:15:49 2023
    NAMESPACE: monitoring
    STATUS: deployed
    REVISION: 1
    NOTES:
    kube-prometheus-stack has been installed. Check its status by running:
    kubectl --namespace monitoring get pods -l "release=kube-prometheus-stack"

    Visit https://github.com/prometheus-operator/kube-prometheus for instructions on how to create & configure Alertmanager and Prometheus instances using the Operator.
    ```  
    Crear los port-forward de las distintas aplicaciones, hemos creado los port-forward a los pod pero como cambian, se pueden realizar a los servicios que son más estáticos, sino habría que listar los pods y ver los nombres como en nuestro caso para ralizar los port-forward:
    ```
    $ kubectl -n monitoring port-forward kube-prometheus-stack-grafana-855cf5d45b-kc2jm 8282:3000
    Forwarding from 127.0.0.1:8282 -> 3000
    Forwarding from [::1]:8282 -> 3000
    ```
    ```
    $ kubectl -n simpleserver port-forward simpleserver-78b4d9875-m75mq 8081:8081
    Forwarding from 127.0.0.1:8081 -> 8081
    Forwarding from [::1]:8081 -> 8081
    ```
    ```
    $ kubectl -n monitoring port-forward svc/kube-prometheus-stack-prometheus 9090:9090
    Forwarding from 127.0.0.1:9090 -> 9090
    Forwarding from [::1]:9090 -> 9090
    ```


## Creación de pipelines CI/CD

Se ha utilizado Github Actions para tocar algo nuevo, con la configuración establecida en los ficheros yaml del directorio `.github/workflows`.  

Crear un token personal con los permisos de manejo de `packages`:  

Creamos los secretos para poder hacer login frente a los registros de contenedores. Esto se define en la sección de `Actions` de los `Settings` de nuestro repositorio de Github:  

La ejecución de los pipelines se encuentra en la sección `Actions` de nuestro proyecto:  

Los artefactos generados se publican tanto ghcr.io.

## Creación de alarmas.
Para la creación de alarmas configuraremos en nuestro Slack una canal para las alertas como se hizo en la práctica 3 e introduciendo en nuestro archivo `/prometheus/values.yaml` lo siguiente:
```
slack_configs:
      - api_url: 'https://hooks.slack.com/services/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' # <--- AÑADIR EN ESTA LÍNEA EL WEBHOOK CREADO
        send_resolved: true
        channel: '#marianomb82-prometheus-alarms' # <--- AÑADIR EN ESTA LÍNEA EL CANAL
``` 
## Creación de Dashboad en Grafana.
Después de realizar múltiples pruebas para dar con  la solución de lo solicitado en esta parte de la práctica, para la query de 