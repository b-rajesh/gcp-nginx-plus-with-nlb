# Provider
provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zones
}

resource "random_pet" "pet-prefix" {
  length = 1
  prefix = var.prefix
}

# VPC
resource "google_compute_network" "vpc" {
  name                    = "${random_pet.pet-prefix.id}-${var.network}"
  auto_create_subnetworks = "false"
}

# API Gateway Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "${random_pet.pet-prefix.id}-${var.gwy_subnet}"
  region        = var.region
  network       = google_compute_network.vpc.name
  ip_cidr_range = var.gwy_subnet_cidr
}

# Microservice Subnet
resource "google_compute_subnetwork" "microservice-subnet" {
  name          = "${random_pet.pet-prefix.id}-${var.microservice_subnet}"
  region        = var.region
  network       = google_compute_network.vpc.name
  ip_cidr_range = var.microservice_subnet_cidr

}

resource "google_compute_address" "ext-lb-staticip-address" {
  name = "${random_pet.pet-prefix.id}-ngx-lb-static-ip"
}

