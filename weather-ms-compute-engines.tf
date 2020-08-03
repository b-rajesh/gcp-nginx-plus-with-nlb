resource "google_compute_firewall" "microservice-firewall-rule" {
  depends_on  = [google_compute_subnetwork.microservice-subnet]
  name        = "microservice-fw-rule"
  network     = var.network
  description = "Allow access to port 3000 to only accessed from nginx plus api gateway."
  allow {
    protocol = "tcp"
    ports = [
      "3000",
    ]
  }
  source_tags = ["nginx-plus-api-gwy"]

  target_tags = [
    "microservices", //the firewall rule applies only to instances in the VPC network that have one of these tags, which would be for nginx instances through templates
  ]
}

resource "google_compute_instance_template" "weather-microservice-template" {
  depends_on  = [google_compute_subnetwork.microservice-subnet]
  name        = "weather-microservice-template"
  tags = ["microservices"]

  labels = {
    environment = "dev"
  }
  machine_type         = var.machine_type
  can_ip_forward       = false

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  disk {
    source_image = var.weather_api_image
    auto_delete  = true
    boot         = true
  }
  network_interface {
    network = google_compute_network.vpc.name
    subnetwork = google_compute_subnetwork.microservice-subnet.name
    access_config {
    }
  }
  service_account {
    scopes = [
      "https://www.googleapis.com/auth/compute",
    ]
  }
  metadata_startup_script = file("${path.module}/startup.sh")
  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_instance_group_manager" "weather-microservice-group-manager" {
  depends_on  = [google_compute_subnetwork.microservice-subnet]
  name               = "weather-ms-instance-group-manager"
  base_instance_name = "weather-microservice"
  zone               = var.zones
  target_size        = "3"
  //target_pools       = [google_compute_target_pool.ms-internal-target-pool.id]
  version {
    instance_template = google_compute_instance_template.weather-microservice-template.id
  }
}

resource "null_resource" "weather-api-upstream" {
  depends_on  = [google_compute_region_backend_service.microservice-backend,google_compute_instance_template.nginx-plus-gwy-template, google_compute_forwarding_rule.ms-internal-lb-forwarding-rule, google_compute_forwarding_rule.gce-ext-lb-80-forwarding-rule]
  provisioner "local-exec" {
    command = "curl -X POST -d '{\"server\": \"${google_compute_forwarding_rule.ms-internal-lb-forwarding-rule.ip_address}:3000\"}' -s  'http://${google_compute_forwarding_rule.gce-ext-lb-80-forwarding-rule.ip_address}:8080/api/6/http/upstreams/weather_api/servers'"
  }
}