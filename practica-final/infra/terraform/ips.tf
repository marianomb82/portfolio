#IP fijas para los recursos
resource "google_compute_address" "ipv4_fastapi" {
  name = "ipv4-fastapi"
}

resource "google_compute_address" "ipv4_prometheus" {
  name = "ipv4-prometheus"
}

resource "google_compute_address" "ipv4_grafana" {
  name = "ipv4-grafana"
}

resource "google_compute_address" "ipv4_alertmanager" {
  name = "ipv4-alertmanager"
}