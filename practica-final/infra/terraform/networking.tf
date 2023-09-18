#Recursos de red del proyecto
resource "google_compute_network" "zasema_paradigma_vpc" {
  project                                   = var.project_id
  name                                      = "zasema-paradigma-vpc"
  auto_create_subnetworks                   = true
  network_firewall_policy_enforcement_order = "BEFORE_CLASSIC_FIREWALL"
}

