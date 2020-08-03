

resource "google_compute_forwarding_rule" "ms-internal-lb-forwarding-rule-f1" {
  depends_on            = [google_compute_subnetwork.microservice-subnet]
  network               = google_compute_network.vpc.name
  subnetwork            = google_compute_subnetwork.microservice-subnet.name
  region                = var.region
  name                  = "f1-ms-internal-lb"
  backend_service       = google_compute_region_backend_service.f1-microservice-backend.id
  load_balancing_scheme = "INTERNAL"
  ip_address            = google_compute_address.f1-internal_lb-ip.address
  ip_protocol           = "TCP"
  ports                 = ["3000"]
  
}

resource "google_compute_health_check" "f1-ms-healthcheck" {
  name                  = "f1-api-healthcheck"
  http_health_check {
    port                = "3000"
    request_path        = "/f1-api/health"
  }
}

resource "google_compute_region_backend_service" "f1-microservice-backend" {
  name          = "f1-microservice-backend"
  region        = var.region
  backend {
    group       = google_compute_instance_group_manager.f1-microservice-group-manager.instance_group
  }
  health_checks = [google_compute_health_check.f1-ms-healthcheck.id]
}

resource "google_compute_address" "f1-internal_lb-ip" {
  name         = "f1-internal-loadbalancer-ip"
  subnetwork   = google_compute_subnetwork.microservice-subnet.id
  address_type = "INTERNAL"
  region        = var.region
}


