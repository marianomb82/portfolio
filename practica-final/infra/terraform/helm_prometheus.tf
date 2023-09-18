# Creando namespace fastapi
resource "kubernetes_namespace" "prometheus_fastapi" {
  metadata {
    name = "monitoring"
  }
}

# Instalar el chart de kube-prometheus-stack
resource "helm_release" "helm_prometheus_fastapi" {
  name              = "prometheus"
  repository        = "https://prometheus-community.github.io/helm-charts"
  chart             = "kube-prometheus-stack"
  namespace         = kubernetes_namespace.prometheus_fastapi.metadata[0].name
  create_namespace  = true
  wait              = true

  values = [
    file("../../k8s/kube-prometheus-stack/values.yaml")
  ]

  set {
    name  = "prometheus.service.loadBalancerIP"
    value = google_compute_address.ipv4_prometheus.address
  }

  set {
    name  = "alertmanager.service.loadBalancerIP"
    value = google_compute_address.ipv4_alertmanager.address
  }
    set {
    name  = "service.loadBalancerIP"
    value = google_compute_address.ipv4_grafana.address
  }

   set {
    name  = "grafana.service.loadBalancerIP"
    value = google_compute_address.ipv4_grafana.address
  }

}