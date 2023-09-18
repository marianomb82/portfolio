#!/bin/bash
# ----------------------------------------------------------------------------------------------------

argopass="$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)"

echo "ArgoCD login"
echo "         url: http://localhost:8088"
echo "        user: admin"
echo "        pass: ${argopass}"

echo "Forwarding ArgoCD port 8088:443..."
kubectl port-forward service/argocd-server -n argocd 8088:443

#
# eof
#