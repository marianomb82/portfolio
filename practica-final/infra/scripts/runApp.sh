#!/bin/bash
#
#: ####################################################################################
#:  runApp.sh
#:
#:      -h:     Ayuda del comando
#:      -c:     Desplegar en local con docker compose (default)
#:      -k:     Desplegar en Kubernetes sin métricas, solo la app
#:      -m:     Desplegar en Kubernetes con métricas de prometheus activas
#: ####################################################################################

# >> die:
die()
{
    echo "$@"
    usage
    exit 1
}

# >> usage:
usage()
{
    printf "Usage: ${scriptname} -h|-m|-M|-k|-K|-c|-C\n"
    printf "    -h : Show this help\n"
    printf "    -m : Deploy app in k8s (minikube) with Helm (app & monitoring)\n"
    printf "    -M : Delete '-m' deployment\n"
    printf "    -k : Deploy app in k8s (minikube) with Helm (only app)\n"
    printf "    -K : Delete '-k' deployment\n"
    printf "    -c : Deploy app on-premise with docker compose (only app)\n"
    printf "    -C : Delete '-c' deployment\n"
    exit 0
}

# ------------------------------------------------------------------------------------

# Minikube
startMinikube()
{
    minikube start --kubernetes-version='v1.26.1' \
                   --memory=4096 \
                   --addons="metrics-server,default-storageclass,storage-provisioner" \
                   -p monitoring-paradigma
}
stopMinikube()
{
    minikube stop
    minikube delete -p monitoring-paradigma
}

# Docker Compose
runCompose()
{
    docker compose up --build
}
stopCompose()
{
    docker compose down
}

# Minikube - Only app
runKubeAppStandalone()
{
    helm -n paradigma-fastapi upgrade paradigma --set metrics.enabled=false \
                                        --wait \
                                        --install \
                                        --create-namespace ./paradigma
}
# Minikube - App & Metrics
runKubeApp()
{
    helm -n paradigma-fastapi upgrade paradigma \
                                        --wait \
                                        --install \
                                        --create-namespace ./paradigma
}
stopKubeApp()
{
    helm -n paradigma-fastapi uninstall paradigma
}

# Minikube - App & Metrics
runKubeMonitor()
{
    helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
    helm repo update
    helm -n monitoring upgrade \
        --install prometheus prometheus-community/kube-prometheus-stack \
         -f ./kube-prometheus-stack/values.yaml \
        --create-namespace \
        --wait \
        --version 34.1.1 \
        --debug

}
stopKubeMonitor()
{
    helm -n monitoring uninstall prometheus
}


# ------------------------------------------------------------------------------------
scriptname="${0##*/}"
CURRENT_DIR="$(pwd)"

# Get current script full path
[ "${0:0:1}" == "/" ] && fullpath="${0}" || fullpath="$(echo "${CURRENT_DIR}/${0}" | sed 's@\./@@g')"

# Get k8s directory
k8spath="$(echo "${fullpath}" | rev | cut -d "/" -f 4-100 | rev)/k8s"

# Set k8s current directory
cd "${k8spath}"

# Parse input parameters
optionstring=hcCkKmM
while getopts $optionstring opt 2>/dev/null; do
    case $opt in
        h)  # Ayuda del comando
            usage
            ;;
        c)  # Solo app con docker compose
            runCompose
            ;;
        C)  # Detener 'c' previo
            stopCompose
            ;;
        k)  # Solo app con minikube
            startMinikube
            runKubeAppStandalone
            ;;
        K)  # Detener 'k' previo
            stopKubeApp
            stopMinikube
            ;;
        m)  # App y Monitor con minikube
            startMinikube
            runKubeMonitor
            runKubeApp
            ;;
        M)  # Detener 'm' previo
            stopKubeApp
            stopKubeMonitor
            stopMinikube
            ;;
        *)  # 
            die "Invalid parameter [${opt}]"
            ;;
    esac
done
shift "$(( $OPTIND - 1 ))"

exit 0

#: ####################################################################################
#: eof: runApp.sh
#: ####################################################################################
