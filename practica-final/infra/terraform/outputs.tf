# Salidas de las variables y recursos de terraform/google

# ID proyecto y región

output "project_id" {
  value       = var.project_id
  description = "GCloud Project ID"
}

output "region" {
  value       = var.region
  description = "GCloud Region"
}


output "zone" {
  value       = var.zone
  description = "GCloud Zone"
}

# Kubernetes

output "gke_num_nodes" {
  value       = var.gke_num_nodes
  description = "number of gke nodes"
}

output "kubernetes_cluster_name" {
  value       = google_container_cluster.zasema_paradigma_cluster.name
  description = "GKE Cluster Name"
}

output "kubernetes_cluster_endpoint" {
  value       = google_container_cluster.zasema_paradigma_cluster.endpoint
  description = "GKE Cluster Host"
}

