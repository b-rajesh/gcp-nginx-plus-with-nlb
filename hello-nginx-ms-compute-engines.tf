resource "google_compute_instance_template" "hello-nginx-microservice-template" {
  depends_on  = [google_compute_subnetwork.microservice-subnet, google_compute_instance_template.nginx-plus-gwy-template]
  name        = "${random_pet.pet-prefix.id}-hello-nginx-microservice-template"
  tags = ["${random_pet.pet-prefix.id}-microservices"] #One firewall rule to let nginxplus to talk to the services deployed in the microservice subnet

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
    source_image = var.hello_nginx_api_image
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

resource "google_compute_instance_group_manager" "hello-nginx-microservice-group-manager" {
  depends_on  = [google_compute_subnetwork.microservice-subnet]
  name               = "${random_pet.pet-prefix.id}-hello-nginx-ms-instance-group-manager"
  base_instance_name = "hello-nginx-microservice"
  zone               = var.zones
  target_size        = "3"
  //target_pools       = [google_compute_target_pool.ms-internal-target-pool.id]
  version {
    instance_template = google_compute_instance_template.hello-nginx-microservice-template.id
  }
}

resource "null_resource" "hello-nginx-api-upstream" {
  depends_on  = [google_compute_region_backend_service.hello-nginx-microservice-backend,google_compute_instance_template.nginx-plus-gwy-template, google_compute_forwarding_rule.ms-internal-lb-forwarding-rule-hello-nginx, google_compute_forwarding_rule.gce-ext-lb-80-forwarding-rule]
  provisioner "local-exec" {
    command = "curl -X POST -d '{\"server\": \"${google_compute_forwarding_rule.ms-internal-lb-forwarding-rule-hello-nginx.ip_address}:3000\"}' -s  'http://${google_compute_forwarding_rule.gce-ext-lb-80-forwarding-rule.ip_address}:8080/api/6/http/upstreams/hello_nginx_api/servers'"
  }
}