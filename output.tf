output "weather_api_url" {
  description = "Curl command to access weather API"
  value       = "curl http://${google_compute_forwarding_rule.gce-ext-lb-80-forwarding-rule.ip_address}/weather?city=melbourne -H 'Authorization: Bearer ' "
}

output "hello-nginxplus_api_url" {
  description = "HTTPie command to access Hellow NGINX Plus API"
  value       = "http ${google_compute_forwarding_rule.gce-ext-lb-80-forwarding-rule.ip_address}/hello-nginxplus-api 'Authorization: Bearer '"
}

output "f1_api_url" {
  description = "HTTPie command to access F1 detail through API"
  value       = "http ${google_compute_forwarding_rule.gce-ext-lb-80-forwarding-rule.ip_address}/f1-api/f1/drivers.json 'Authorization: Bearer '"
}

output "nginxplus_dashboard_url" {
  description = "NGINX Plus dashboard App"
  value       = "http://${google_compute_forwarding_rule.gce-ext-lb-80-forwarding-rule.ip_address}:8080/dashboard.html"
}

output "admin_api_url" {
  description = "HTTPie command to access Admin API"
  value       = "http ${google_compute_forwarding_rule.gce-ext-lb-80-forwarding-rule.ip_address}:8080/api/6/http/upstreams"
}