variable "project_id" {
  description = "project id"
}

variable "region" {
  description = "region"
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# VPC
resource "google_compute_network" "vpc-frontend" {
  name                    = "${var.project_id}-vpc-1"
  auto_create_subnetworks = "false"
}

# Subnet
resource "google_compute_subnetwork" "subnet-frontend" {
  name          = "${var.project_id}-subnet-1"
  region        = var.region
  network       = google_compute_network.vpc-frontend.name
  ip_cidr_range = "10.10.0.0/24"

}


# VPC
resource "google_compute_network" "vpc-backend" {
  name                    = "${var.project_id}-vpc-2"
  auto_create_subnetworks = "false"
}

# Subnet
resource "google_compute_subnetwork" "subnet-backend" {
  name          = "${var.project_id}-subnet-2"
  region        = var.region
  network       = google_compute_network.vpc-backend.name
  ip_cidr_range = "10.11.0.0/24"

}

output "region" {
  value       = var.region
  description = "region"
}

