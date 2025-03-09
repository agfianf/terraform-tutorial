resource "google_compute_network" "vpc_vm" {
    name = var.vpc_name
    auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "vpc_subnet_vm" {
    name          = var.subnet_name
    ip_cidr_range = var.subnet_ip_range
    region        = var.region
    network       = google_compute_network.vpc_vm.id
}

# create firewall rule for ssh access --
resource "google_compute_firewall" "allow_ssh" {
    name = "allow-ssh"
    network = google_compute_network.vpc_vm.id

    allow {
      protocol = "tcp"
      ports = ["22"]
    }

    source_ranges = ["0.0.0.0/0"] # artinya, semua ip dianggap boleh masuk
    target_tags = ["ssh-access"]
}

# create http 80 firewall
resource "google_compute_firewall" "allow_http" {
    name = "allow-http"
    network = google_compute_network.vpc_vm.id

    allow {
      protocol = "tcp"
      ports = [ "80" ]
    }

    source_ranges = [ "0.0.0.0/0" ] # artinya, semua ip dianggap boleh masuk
    target_tags = ["http-access"]
}