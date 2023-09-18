# Con este fichero se crea la zona dns y sus registros, previamente hay que tener comprado el dominio
# una vez realizado mediante el atributo "name_servers" se averiguan los servidores dns asignados por google
# y se modifican en el dominio.

# Creando la zona dns
resource "google_dns_managed_zone" "zasema_paradigma_zone" {
  name        = "zasema-paradigma-zone"
  dns_name    = "zasema-paradigma.com."
  description = "Zona DNS del proyecto zasema-paradigma"
}

#Añadiendo el registro "A" de app a la zona dns para la fastapi
resource "google_dns_record_set" "zasema_paradigma_fastapi_dns" {
  managed_zone = google_dns_managed_zone.zasema_paradigma_zone.name
  name         = "fastapi.zasema-paradigma.com."
  type         = "A"
  rrdatas      = [google_compute_address.ipv4_fastapi.address]#ip que se le asigna
  ttl          = 300
}
#Añadiendo el registro "A" de app a la zona dns para prometheus
resource "google_dns_record_set" "zasema_paradigma_prometheus_dns" {
  managed_zone = google_dns_managed_zone.zasema_paradigma_zone.name
  name         = "prometheus.zasema-paradigma.com."
  type         = "A"
  rrdatas      = [google_compute_address.ipv4_prometheus.address]#ip que se le asigna
  ttl          = 300
}

#Añadiendo el registro "A" de app a la zona dns para grafana
resource "google_dns_record_set" "zasema_paradigma_grafana_dns" {
  managed_zone = google_dns_managed_zone.zasema_paradigma_zone.name
  name         = "grafana.zasema-paradigma.com."
  type         = "A"
  rrdatas      = [google_compute_address.ipv4_grafana.address]#ip que se le asigna
  ttl          = 300
}

#Añadiendo el registro "A" de app a la zona dns para alertmanager
resource "google_dns_record_set" "zasema_paradigma_alertmanager_dns" {
  managed_zone = google_dns_managed_zone.zasema_paradigma_zone.name
  name         = "alertmanager.zasema-paradigma.com."
  type         = "A"
  rrdatas      = [google_compute_address.ipv4_alertmanager.address]#ip que se le asigna
  ttl          = 300
}