# VPC
resource "google_compute_network" "vpc" {
  name                    = "demo-vpc"
  auto_create_subnetworks = false
  project                 = var.project_id
}

# Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "demo-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = var.region
  project       = var.project_id
  network       = google_compute_network.vpc.id
}

# Firewall
resource "google_compute_firewall" "firewall" {
  name    = "allow-http-ssh"
  network = google_compute_network.vpc.name
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["22", "80"]
  }

  source_ranges = ["0.0.0.0/0"]
}

# VM
resource "google_compute_instance" "vm" {
  name         = "demo-vm"
  machine_type = "e2-micro"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet.id
    access_config {}
  }
}

# Bucket
resource "google_storage_bucket" "bucket" {
  name     = "${var.project_id}-demo-bucket"
  location = var.region
  project  = var.project_id
}
