

resource "google_compute_forwarding_rule" "gce-ext-lb-80-forwarding-rule" {
  depends_on            = [google_compute_subnetwork.subnet]
  //network               = google_compute_network.vpc.name
  //subnetwork            = google_compute_subnetwork.subnet.name
  region                = var.region
  name                  = "gce-external-lb-80"
  target                = google_compute_target_pool.default.self_link
  load_balancing_scheme = "EXTERNAL"
  //network_tier           = "STANDARD"
  ip_address            = google_compute_address.ext-lb-staticip-address.address
  ip_protocol           = var.protocol
  port_range            = "80"
  
}

resource "google_compute_forwarding_rule" "gce-ext-lb-8080-forwarding-rule" {
  depends_on            = [google_compute_subnetwork.subnet]
  //network               = google_compute_network.vpc.name
  //subnetwork            = google_compute_subnetwork.subnet.name
  region                = var.region
  name                  = "gce-external-lb-8080"
  target                = google_compute_target_pool.default.self_link
  load_balancing_scheme = "EXTERNAL"
  //network_tier           = "STANDARD"
  ip_address            = google_compute_address.ext-lb-staticip-address.address
  ip_protocol           = var.protocol
  port_range            = "8080"  
}



resource "google_compute_target_pool" "default" {
  name             = "ext-loadbalancer-nginx-plus"
  //instances        = google_compute_instance_group_manager.nginx-plus-gwy-group-manager.self_link
  //session_affinity = var.session_affinity
  health_checks = google_compute_http_health_check.default.*.name
}

resource "google_compute_http_health_check" "default" {
  name    = "nginx-plus-health-check"

  request_path        = var.health_check_path
  port                = var.health_check_port
  check_interval_sec  = var.health_check_interval
  healthy_threshold   = var.health_check_healthy_threshold
  unhealthy_threshold = var.health_check_unhealthy_threshold
  timeout_sec         = var.health_check_timeout
}


/*
resource "google_compute_firewall" "nlb-ingress-firewall-rule" {
  name        = "nlb-ingress-fw-rule"
  network     = var.network
  description = "Allow access to ports 80,443 and 8080 on all NGINX plus instances."
  allow {
    protocol = "tcp"
    ports = [
      "80",
      "443",
      "8080",
    ]
  }
  //source_tags = ["gce-nlb-only"]
  source_ranges = [
    "0.0.0.0/0" //firewall rule applies only to traffic that has a source IP address in these ranges
  ]
  target_tags = [
    "nginx-plus-api-gwy", //the firewall rule applies only to instances in the VPC network that have one of these tags
  ]
}
*/