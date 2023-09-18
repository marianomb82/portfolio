terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.49.0"
    }
  }
}

provider "google" {
  credentials = file("cred_gcp7.json")
  
  project = "gcp7-mariano-martin"
  region = "europe-southwest1"
  zone = "europe-southwest1-a"
}

resource "google_compute_network" "vpc_network-gcp7" {
  name = "gcp7-mariano-martin-network"
}

resource "google_compute_address" "ip_estatica_gcp7" {
  name = "static-ip"
}

resource "google_compute_instance" "vm_gcp7" {
    depends_on = [
      google_compute_network.vpc_network-gcp7,
      google_compute_address.ip_estatica_gcp7
    ]
  name = "vm-gcp7"
  machine_type = "e2-micro"

  boot_disk {
    initialize_params{
        image = "projects/ubuntu-os-cloud/global/images/ubuntu-2204-jammy-v20230114"
    }
  }

 network_interface {
    network = google_compute_network.vpc_network-gcp7.name
    access_config {
      nat_ip = google_compute_address.ip_estatica_gcp7.address
    }
  }
}

resource "random_string" "texto_aleatorio" {
  length = 5
  special = false
  upper = false
}

resource "google_storage_bucket" "bucket_gcp7" {
  name = "bucket-gcp7-${random_string.texto_aleatorio.result}"
  location = "europe-southwest1"
}
