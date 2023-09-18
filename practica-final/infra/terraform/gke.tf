#Recursos GKE
resource "google_container_cluster" "zasema_paradigma_cluster" {
  name     = var.project_id
  location = var.region

  node_config {
    disk_size_gb = 15
    machine_type = "e2-standard-2"
  }
  cluster_autoscaling {
    enabled = true
    resource_limits {
      resource_type = "cpu"
      maximum       = 2
    }
    resource_limits {
      resource_type = "memory"
      maximum       = 4
    }
  }
  remove_default_node_pool = true
  initial_node_count       = 1
  network                  = google_compute_network.zasema_paradigma_vpc.id

  #ignorar los cambios para que no se destruya el recurso
  lifecycle {
    ignore_changes = all
  }
}

# Creamos los nodos despues de desplegar el cluster en este caso 2.
resource "google_container_node_pool" "primary_nodes" {
  name       = "${google_container_cluster.zasema_paradigma_cluster.name}-node-pool"
  location   = var.zone
  cluster    = google_container_cluster.zasema_paradigma_cluster.id
  node_count = var.gke_num_nodes

  node_config {
    disk_size_gb = 15
    machine_type = "e2-standard-2"
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels = {
      env = var.project_id
    }

    tags = ["gke-node", "zasema-paradigma-gke"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }

  lifecycle {
    ignore_changes = all
  }
}