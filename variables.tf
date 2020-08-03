variable "network" {}
variable "gwy_subnet" {}
variable "project_id" {}
variable "region" {}
variable "gwy_subnet_cidr" {}
variable "machine_type" {}
variable "f1_api_image" {}
variable "hello_nginx_api_image" {}
variable "gce_image_name"  {
  description = "Assuming you would have run the packer to build the image, you could override this in terraform.tfvars"
  default = "nginxplus-r22"
}
variable "weather_api_image" {
  description = "Assuming you would have run the packer to build the image, you could override this in terraform.tfvars"
  default = "weather-api-v1"
}
variable "zones" {}
variable "microservice_subnet" {}
variable "microservice_subnet_cidr" {}
variable "protocol" {
  description = "The protocol for the backend and frontend forwarding rule. TCP or UDP."
  type        = string
  default     = "TCP"
}

variable "ip_address" {
  description = "IP address of the load balancer. If empty, an IP address will be automatically assigned."
  type        = string
  default     = null
}

variable "port_range" {
  description = "Only packets addressed to ports in the specified range will be forwarded to target. If empty, all packets will be forwarded."
  type        = string
  default     = null
}

variable "enable_health_check" {
  description = "Flag to indicate if health check is enabled. If set to true, a firewall rule allowing health check probes is also created."
  type        = bool
  default     = false
}

variable "health_check_port" {
  description = "The TCP port number for the HTTP health check request."
  type        = number
  default     = 8080
}

variable "health_check_healthy_threshold" {
  description = "A so-far unhealthy instance will be marked healthy after this many consecutive successes. The default value is 2."
  type        = number
  default     = 2
}

variable "health_check_unhealthy_threshold" {
  description = "A so-far healthy instance will be marked unhealthy after this many consecutive failures. The default value is 2."
  type        = number
  default     = 2
}

variable "health_check_interval" {
  description = "How often (in seconds) to send a health check. Default is 5."
  type        = number
  default     = 5
}

variable "health_check_timeout" {
  description = "How long (in seconds) to wait before claiming failure. The default value is 5 seconds. It is invalid for 'health_check_timeout' to have greater value than 'health_check_interval'"
  type        = number
  default     = 5
}

variable "health_check_path" {
  description = "The request path of the HTTP health check request. The default value is '/api'."
  type        = string
  default     = "/api"
}