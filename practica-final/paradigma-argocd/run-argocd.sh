#!/bin/bash
# ----------------------------------------------------------------------------------------------------

scriptname="${0##*/}"
CURRENT_DIR="$(pwd)"
[ "${0:0:1}" == "/" ] && fullpath="${0}" || fullpath="$(echo "${CURRENT_DIR}/${0}" | sed 's@\./@@g')"
k8spath="$(echo "${fullpath}" | rev | cut -d "/" -f 2-100 | rev)"
echo "Working dir is '${k8spath}'"
cd "${k8spath}"


echo "Starting minikube..."
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
minikube profile paradigma-argocd


echo "Starting ArgoCD..."
helm -n argocd upgrade --install argocd argo/argo-cd \
  -f argocd/values.yaml \
  -f argocd/values-secret.yaml \
  --create-namespace \
  --wait --version 5.34.1


echo "Starting ArgoCD Apps..."
helm -n argocd upgrade --install argocd-apps argo/argocd-apps --create-namespace --wait --version 1.1.0


echo "Work done."
#
# eof
#