# Creando namespace fastapi
resource "kubernetes_namespace" "paradigma_fastapi" {
  metadata {
    name = "paradigma-fastapi"
  }
}

# Desplegando ingress-controler con helm para el namespace de la app
resource "helm_release" "helm_app_fastapi" {
  name             = "app-fastapi-paradigma"
  chart            = "../../k8s/paradigma"
  namespace        = kubernetes_namespace.paradigma_fastapi.metadata[0].name
  create_namespace = true
  wait             = true

  # Esperar al despliegue de kube-prometheus-stack
  depends_on = [
    helm_release.helm_prometheus_fastapi
  ]

  set {
    name  = "controller.service.loadBalancerIP"
    value = google_compute_address.ipv4_fastapi.address
  }
}