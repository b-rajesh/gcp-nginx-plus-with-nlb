resource "google_compute_forwarding_rule" "ms-internal-lb-forwarding-rule-hello-nginx" {
  depends_on            = [google_compute_subnetwork.microservice-subnet]
  network               = google_compute_network.vpc.name
  subnetwork            = google_compute_subnetwork.microservice-subnet.name
  region                = var.region
  name                  = "${random_pet.pet-prefix.id}-hello-nginx-ms-internal-lb"
  backend_service       = google_compute_region_backend_service.hello-nginx-microservice-backend.id
  load_balancing_scheme = "INTERNAL"
  ip_address            = google_compute_address.hello-nginx-internal_lb-ip.address
  ip_protocol           = "TCP"
  ports                 = ["3000"]
  
}

resource "google_compute_health_check" "hello-nginx-ms-healthcheck" {
  name                  = "${random_pet.pet-prefix.id}-hello-nginx-api-healthcheck"
  http_health_check {
    port                = "3000"
    request_path        = "/hello-nginxplus-api/health"
  }
}

resource "google_compute_region_backend_service" "hello-nginx-microservice-backend" {
  name          = "${random_pet.pet-prefix.id}-hello-nginx-microservice-backend"
  region        = var.region
  backend {
    group       = google_compute_instance_group_manager.hello-nginx-microservice-group-manager.instance_group
  }
  health_checks = [google_compute_health_check.f1-ms-healthcheck.id]
}

resource "google_compute_address" "hello-nginx-internal_lb-ip" {
  name         = "${random_pet.pet-prefix.id}-hello-nginx-internal-loadbalancer-ip"
  subnetwork   = google_compute_subnetwork.microservice-subnet.id
  address_type = "INTERNAL"
  region        = var.region
}


