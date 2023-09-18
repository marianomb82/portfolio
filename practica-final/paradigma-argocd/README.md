# Paradigma Team GitOps with ArgoCD

# Contenido copiado desde repositorio original para la entrega del proyecto:

`https://github.com/zasema/paradigma-argocd`


## Despliegue continuo de `paradigma`, con ArgoCD y ArgoCD-Apps:

1. Crear un clúster de minikube:
```
minikube start --driver=docker \
    --kubernetes-version='v1.26.1' \
    --cpus=2 \
    --memory=4096 \
    --addons=metrics-server \
    --addons=storage-provisioner \
    --addons=ingress-dns \
    --addons=ingress \
    --host-dns-resolver=true \
    -p paradigma-argocd
```

2. Crear un par de claves ssh:
```
$ ssh-keygen -t ed25519 -f ~/.ssh/paradigma_argocd_deploy_key
```

3. Añadir la clave pública generada, como Deploy Key, al repositorio de github, habilitando el checkbox `Allow write access`.

4. Crear un nuevo fichero `argocd/values-secret.yaml`, con el contenido de la clave privada en el siguiente formato:
```
configs:
  credentialTemplates:
    paradigma-creds:
      url: git@github.com:zasema/paradigma-argocd
      sshPrivateKey: |
        -----BEGIN OPENSSH PRIVATE KEY-----
        XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
        XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
        XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
        XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
        XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
        -----END OPENSSH PRIVATE KEY-----
```

5. Desplegar ArgoCD
```
helm -n argocd upgrade --install argocd argo/argo-cd \
  -f argocd/values.yaml \
  -f argocd/values-secret.yaml \
  --create-namespace \
  --wait --version 5.34.1
```

6. Desplegar ArgoCD Apps
```
helm -n argocd upgrade --install argocd-apps argo/argocd-apps \
  -f argocd/values-apps.yaml \
  --create-namespace --wait --version 1.1.0
```

7. Hacer un port-forward al servicio de ArgoCD al puerto 8088 local:
```
kubectl port-forward service/argocd-server -n argocd 8088:443
```

8. Obtener la password de ArgoCD para el usuario `admin`:
```
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d
```

9. Acceder a la url http://localhost:8080 con las credenciales previas.

## Generación de sealed secrets

Puede darse el caso en el que caduque un token de autenticación, o que se cambie de repositorio de imágenes de contenedor privado.   
En tales casos, será necesario generar nuevos secretos, así como reemplazar los manifiestos correspondientes.   
Aquí las instrucciones para ello:

1. Generar un par de claves RSA:
```
export PRIVATEKEY="mytls.key"
export PUBLICKEY="mytls.crt"
export NAMESPACE="secrets"
export SECRETNAME="sealed-secrets-key"

openssl req -x509 -days 365 -nodes -newkey rsa:4096 -keyout "$PRIVATEKEY" -out "$PUBLICKEY" -subj "/CN=sealed-secret/O=sealed-secret"
```

2. Crear un Secret tls, utilizando el par de claves RSA creado anteriormente, en su propio namespace:
```
kubectl create namespace $NAMESPACE

kubectl -n "$NAMESPACE" create secret tls \
  "$SECRETNAME" --cert="$PUBLICKEY" \
  --key="$PRIVATEKEY"
kubectl -n "$NAMESPACE" label secret \
  "$SECRETNAME" \
  sealedsecrets.bitnami.com/sealed-secrets-key=active
```

3. Desplegar ArgoCD Apps (necesario para crear los Secrets en el clúster):
```
helm -n argocd upgrade --install argocd-apps argo/argocd-apps \
  -f argocd/values-apps.yaml \
  --create-namespace --wait --version 1.1.0
```

4. Crear los Secrets con kubeseal:
```
kubectl create secret docker-registry registry-credential \
--docker-server="https://index.docker.io/v1/" \
--docker-username="zasema" \
--docker-password="<auth_token_docker_registry>" \
--dry-run=client \
-n paradigma-fastapi \
-o yaml > simple_secret.yaml

kubectl create secret docker-registry reg-cred-argocd-image-updater \
--docker-server="https://registry-1.docker.io/" \
--docker-username="zasema" \
--docker-password="<auth_token_docker_registry>" \
--dry-run=client \
-n paradigma-fastapi \
-o yaml > reg_cred.yaml

cat simple_secret.yaml | kubeseal \
    --controller-namespace secrets \
    --controller-name sealed-secrets \
    --format yaml \
    -n paradigma-fastapi \
    > sealed-secret.yaml

cat reg_cred.yaml | kubeseal \
    --controller-namespace secrets \
    --controller-name sealed-secrets \
    --format yaml \
    -n paradigma-fastapi \
    > sealed-secret-reg-cred.yaml

rm simple_secret.yaml reg_cred.yaml

mv sealed-secret.yaml paradigma/templates/sealed-secret.yaml
mv sealed-secret-reg-cred.yaml paradigma/templates/sealed-secret-reg-cred.yaml
```

5. Subir los cambios al repositorio
```
git add .
git commit -m "fix: update credentials"
git push
```

6. Desplegar las apps de Argo de nuevo, para que se apliquen los nuevos secrets:
```
helm -n argocd upgrade --install argocd-apps argo/argocd-apps \
  -f argocd/values-apps.yaml \
  --create-namespace --wait --version 1.1.0
```