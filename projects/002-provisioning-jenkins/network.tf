resource "google_compute_network" "vpc_name" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "vpc_subnet_vm" {
  name          = var.subnet_name
  ip_cidr_range = var.subnet_ip_range
  region        = var.region
  network       = google_compute_network.vpc_name.id
}

# -- Firewall rules for SSH and HTTP access
resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = google_compute_network.vpc_name.id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"] # Allow SSH from any IP
  target_tags   = ["ssh-access"]
}

resource "google_compute_firewall" "allow_http" {
  name    = "allow-http"
  network = google_compute_network.vpc_name.id

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"] # Allow HTTP from any IP
  target_tags   = ["http-access"]
}

resource "google_compute_firewall" "allow_8080" {
  name    = "allow-8080-jenkins"
  network = google_compute_network.vpc_name.id

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }


  source_ranges = ["0.0.0.0/0"] # Allow HTTP from any IP
  target_tags   = ["port-8080-access"]
}