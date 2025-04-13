# -- VPC and Subnet creation for Self-hosted GitLab --
resource "google_compute_network" "vpc_gitlab" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "vpc_gitlab_subnet" {
  name          = var.subnet_name
  ip_cidr_range = var.subnet_ip_range
  region        = var.region
  network       = google_compute_network.vpc_gitlab.id
}

resource "google_compute_address" "gitlab_static_ip" {
  name   = "gitlab-static-ip"
  region = var.region
}

# --- Firewall rules for SSH and HTTP access ---
resource "google_compute_firewall" "gitlab_firewall" {
  name    = "gitlab-firewall"
  network = google_compute_network.vpc_gitlab.id

  allow {
    protocol = "tcp"
    ports    = ["80", "22", "2222"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["gitlab-port"]
}