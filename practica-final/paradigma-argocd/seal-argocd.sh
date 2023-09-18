#!/bin/bash
# ----------------------------------------------------------------------------------------------------
authToken="${1}"
scriptname="${0##*/}"
CURRENT_DIR="$(pwd)"
[ "${0:0:1}" == "/" ] && fullpath="${0}" || fullpath="$(echo "${CURRENT_DIR}/${0}" | sed 's@\./@@g')"
k8spath="$(echo "${fullpath}" | rev | cut -d "/" -f 2-100 | rev)"
echo "Working dir is '${k8spath}'"
cd "${k8spath}"

# No token, no party
[ -z ${authToken} ] && exit 1


echo "Generating Sealed Secrets..."

export PRIVATEKEY="mytls.key"
export PUBLICKEY="mytls.crt"
export NAMESPACE="secrets"
export SECRETNAME="sealed-secrets-key"

openssl req -x509 -days 365 -nodes -newkey rsa:4096 -keyout "$PRIVATEKEY" -out "$PUBLICKEY" -subj "/CN=sealed-secret/O=sealed-secret"

kubectl create namespace $NAMESPACE
kubectl -n "$NAMESPACE" create secret tls "$SECRETNAME" --cert="$PUBLICKEY" --key="$PRIVATEKEY"
kubectl -n "$NAMESPACE" label secret "$SECRETNAME" sealedsecrets.bitnami.com/sealed-secrets-key=active

helm -n argocd upgrade --install argocd-apps argo/argocd-apps \
  -f argocd/values-apps.yaml \
  --create-namespace --wait --version 1.1.0

kubectl create secret docker-registry registry-credential \
--docker-server="https://index.docker.io/v1/" \
--docker-username="zasema" \
--docker-password="${authToken}" \
--dry-run=client \
-n paradigma-fastapi \
-o yaml > simple_secret.yaml

kubectl create secret docker-registry reg-cred-argocd-image-updater \
--docker-server="https://registry-1.docker.io/" \
--docker-username="zasema" \
--docker-password="${authToken}" \
--dry-run=client \
-n paradigma-fastapi \
-o yaml > reg_cred.yaml

cat simple_secret.yaml | kubeseal \
    --controller-namespace secrets \
    --controller-name sealed-secrets \
    --format yaml \
    -n paradigma-fastapi \
    > paradigma/templates/sealed-secret.yaml

cat reg_cred.yaml | kubeseal \
    --controller-namespace secrets \
    --controller-name sealed-secrets \
    --format yaml \
    -n paradigma-fastapi \
    > paradigma/templates/sealed-secret-reg-cred.yaml

rm simple_secret.yaml reg_cred.yaml

git add .
git commit -m "fix: update sealed-secret credentials"
git push

sleep 5
helm -n argocd upgrade --install argocd-apps argo/argocd-apps \
  -f argocd/values-apps.yaml \
  --create-namespace --wait --version 1.1.0


echo "Work done."
#
# eof
#