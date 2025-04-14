# -- VPC and Subnet creation for FastAPI App --
resource "google_compute_network" "vpc_fastapi" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "vpc_fastapi_subnet" {
  name          = var.subnet_name
  ip_cidr_range = var.subnet_ip_range
  region        = var.region
  network       = google_compute_network.vpc_fastapi.id
}

resource "google_compute_address" "fastapi_static_ip" {
  name   = "fastapi-static-ip"
  region = var.region
}

# --- Firewall rules for SSH and HTTP access ---
resource "google_compute_firewall" "fastapi_firewall" {
  name    = "fastapi-firewall"
  network = google_compute_network.vpc_fastapi.id

  allow {
    protocol = "tcp"
    ports    = ["80", "22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["fastapi-server"]
}