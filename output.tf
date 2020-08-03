
output "weather_api_url" {
  description = "Curl command to access weather API"
  value       = "curl http://${google_compute_forwarding_rule.gce-ext-lb-80-forwarding-rule.ip_address}/weather?city=melbourne"
}
output "hello-nginxplus_api_url" {
  description = "Curl command to access Hellow NGINX Plus API"
  value       = "curl http://${google_compute_forwarding_rule.gce-ext-lb-80-forwarding-rule.ip_address}/hello-nginxplus-api"
}

output "f1_api_url" {
  description = "Curl command to access F1 detail through API"
  value       = "curl http://${google_compute_forwarding_rule.gce-ext-lb-80-forwarding-rule.ip_address}/f1-api/f1/drivers.json"
}

output "nginxplus_dashboard_url" {
  description = "Curl command to access NGINX Plus dashboard App"
  value       = "http://${google_compute_forwarding_rule.gce-ext-lb-80-forwarding-rule.ip_address}:8080/dashboard.html"
}


output "admin_api_url" {
  description = "Curl command to access Admin API"
  value       = "curl http://${google_compute_forwarding_rule.gce-ext-lb-80-forwarding-rule.ip_address}:8080/api/6/http/upstreams"
}


output "inventory_api_url" {
  description = "Curl command to access Inventory API"
  value       = "curl http://${google_compute_forwarding_rule.gce-ext-lb-80-forwarding-rule.ip_address}/warehouse-api/inventory"
}

output "pricing_api_url" {
  description = "Curl command to access Pricing API"
  value       = "curl http://${google_compute_forwarding_rule.gce-ext-lb-80-forwarding-rule.ip_address}/warehouse-api/pricing"
}
