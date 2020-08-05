

resource "google_compute_forwarding_rule" "ms-internal-lb-forwarding-rule" {
  depends_on            = [google_compute_subnetwork.microservice-subnet]
  network               = google_compute_network.vpc.name
  subnetwork            = google_compute_subnetwork.microservice-subnet.name
  region                = var.region
  name                  = "${random_pet.pet-prefix.id}-weather-ms-internal-lb"
  //target                = google_compute_target_pool.default.self_link
  backend_service       = google_compute_region_backend_service.microservice-backend.id
  load_balancing_scheme = "INTERNAL"
  //network_tier           = "STANDARD"
  ip_address            = google_compute_address.address_for_internal_lb.address
  ip_protocol           = "TCP"
  ports                 = ["3000"]
  
}

resource "google_compute_health_check" "weather-api-healthcheck" {
  name                  = "${random_pet.pet-prefix.id}-weather-api-healthcheck"
  http_health_check {
    port                = "3000"
    request_path        = "/weather/health"
  }
}

resource "google_compute_region_backend_service" "microservice-backend" {
  name          = "${random_pet.pet-prefix.id}-weather-microservice-backend"
  region        = var.region
  backend {
    group       = google_compute_instance_group_manager.weather-microservice-group-manager.instance_group
  }
  health_checks = [google_compute_health_check.weather-api-healthcheck.id]
}

resource "google_compute_address" "address_for_internal_lb" {
  name         = "${random_pet.pet-prefix.id}-weather-internal-loadbalancer-ip"
  subnetwork   = google_compute_subnetwork.microservice-subnet.id
  address_type = "INTERNAL"
  region        = var.region
}
