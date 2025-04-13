resource "google_compute_instance" "vm_gitlab_server" {
  name         = var.gitlab_server_name
  machine_type = var.gitlab_server_type_machine
  zone         = var.zone

  tags = [
    tolist(google_compute_firewall.gitlab_firewall.target_tags)[0]
  ]


  labels = {
    environment = "production"
    managed_by  = "terraform"
    usecase     = "gitlab-server"
  }
  boot_disk {
    initialize_params {
      image = var.type_os_image
      size  = var.gitlab_server_disk_size
    }
  }

  network_interface {
    network    = google_compute_network.vpc_gitlab.name
    subnetwork = google_compute_subnetwork.vpc_gitlab_subnet.id

    access_config {
      nat_ip = google_compute_address.gitlab_static_ip.address
    }
  }

  metadata = {
    ssh-keys       = file(var.ssh_public_key_path)
    startup-script = file("scripts/startup_gitlab.sh")
  }

  depends_on = [google_compute_subnetwork.vpc_gitlab_subnet]
}