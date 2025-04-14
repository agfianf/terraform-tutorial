resource "google_compute_instance" "vm_fastapi_server" {
  name         = var.fastapi_server_name
  machine_type = var.fastapi_server_type_machine
  zone         = var.zone

  tags = [
    tolist(google_compute_firewall.fastapi_firewall.target_tags)[0]
  ]

  labels = {
    environment = "production"
    managed_by  = "terraform"
    usecase     = "fastapi-server"
  }
  boot_disk {
    initialize_params {
      image = var.type_os_image
      size  = var.fastapi_server_disk_size
    }
  }

  network_interface {
    network    = google_compute_network.vpc_fastapi.name
    subnetwork = google_compute_subnetwork.vpc_fastapi_subnet.id

    access_config {
      nat_ip = google_compute_address.fastapi_static_ip.address
    }
  }

  metadata = {
    ssh-keys       = file(var.ssh_public_key_path)
    startup-script = file("scripts/startup_fastapi.sh")
  }

  depends_on = [google_compute_subnetwork.vpc_fastapi_subnet]
}