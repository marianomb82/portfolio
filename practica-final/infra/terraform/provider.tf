#Versión del plugin del proveedor que utiliza terraform para google.
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.65.2"
    }
  }
}

#Credenciales para conectar con el proyecto en google.
provider "google" {
  credentials = file("cred.json")
  project     = var.project_id
  region      = var.region
  zone        = var.zone
}

# Obtener datos de la cuenta para utilizarlos. en este caso para el token de autenticación
 data "google_client_config" "provider" {}

#Configuración para poder crear recursos en kubernetes, se utiliza un provider. (Se utiliza el data anterior)
provider "kubernetes" {
  host                   = "https://${google_container_cluster.zasema_paradigma_cluster.endpoint}:443"
  cluster_ca_certificate = base64decode("${google_container_cluster.zasema_paradigma_cluster.master_auth.0.cluster_ca_certificate}")
  token                  = data.google_client_config.provider.access_token
  }

provider "helm" {
  kubernetes {
    host                   = "https://${google_container_cluster.zasema_paradigma_cluster.endpoint}:443"
    client_certificate     = base64decode("${google_container_cluster.zasema_paradigma_cluster.master_auth.0.client_certificate}")
    client_key             = base64decode("${google_container_cluster.zasema_paradigma_cluster.master_auth.0.client_key}")
    cluster_ca_certificate = base64decode("${google_container_cluster.zasema_paradigma_cluster.master_auth.0.cluster_ca_certificate}")
    token                  = data.google_client_config.provider.access_token
  }
}