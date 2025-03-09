
# Create a VM instance
resource "google_compute_instance" "vm_instance" {
  # Create multiple instances based on the instance_count variable
  count        = var.instance_count
  name         = "${var.instance_name}-${count.index}"
  machine_type = var.machine_type
  zone         = var.zone

  # VM instance metadata and labels
  labels = {
    environment = "development"
    managed_by  = "terraform"
  }

  # Boot disk configuration. Use the specified OS image
  boot_disk {
    initialize_params {
      image = var.type_os_image
      size  = 10
    }
  }

  # Network interface configuration
  network_interface {
    # Connect to our custom VPC subnet
    subnetwork = google_compute_subnetwork.vpc_subnet_vm.id
    
    # Request an ephemeral external IP
    access_config {
      # Ephemeral public IP
    }
  }

  tags = [ 
    tolist(google_compute_firewall.allow_http.target_tags)[0],
    tolist(google_compute_firewall.allow_ssh.target_tags)[0],
   ]

  # VM metadata for SSH keys, startup scripts, etc.
  metadata = {
    ssh-keys = file("~/.ssh/id_rsa.pub")
    startup-script = file("files/startup.sh")
  }

  # Ensure VPC is created before instances
  depends_on = [
      google_compute_subnetwork.vpc_subnet_vm
  ]


}
