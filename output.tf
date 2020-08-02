output "internal_load_balancer_ip" {
  value = google_compute_forwarding_rule.ms-internal-lb-forwarding-rule.ip_address
}

output "external_load_balancer_ip" {
  value = google_compute_forwarding_rule.gce-ext-lb-80-forwarding-rule.ip_address
}
