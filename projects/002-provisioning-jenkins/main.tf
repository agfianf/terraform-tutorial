
resource "google_compute_instance" "vm_jenkins_controller" {
  # general configuration
  name         = var.jenkins_controller_name
  machine_type = var.jenkins_controller_type_machine
  zone         = var.zone

  labels = {
    environment = "development"
    managed_by  = "terraform"
    usecase     = "jenkins-controller"
  }

  boot_disk {
    initialize_params {
      image = var.type_os_image
      size  = 15
    }
  }
  network_interface {
    subnetwork = google_compute_subnetwork.vpc_subnet_vm.id

    access_config {
      # Ephemeral public IP
    }
  }

  tags = [
    tolist(google_compute_firewall.allow_ssh.target_tags)[0],
    tolist(google_compute_firewall.allow_8080.target_tags)[0]
  ]

  metadata = {
    ssh-keys       = file("~/.ssh/id_rsa.pub")
    startup-script = file("scripts/startup_controller.sh")
  }

  depends_on = [google_compute_subnetwork.vpc_subnet_vm]
}

resource "google_compute_instance" "vm_jenkins_agent" {
  # general configuration
  name         = var.jenkins_agent_name
  machine_type = var.jenkins_agent_type_machine
  zone         = var.zone

  labels = {
    environment = "development"
    managed_by  = "terraform"
    usecase     = "jenkins-agent"
  }

  boot_disk {
    initialize_params {
      image = var.type_os_image
      size  = 10
    }

  }
  network_interface {
    subnetwork = google_compute_subnetwork.vpc_subnet_vm.id

    access_config {
      # Ephemeral public IP
    }
  }

  tags = [
    tolist(google_compute_firewall.allow_ssh.target_tags)[0]
  ]

  metadata = {
    ssh-keys       = file("~/.ssh/id_rsa.pub")
  }
  metadata_startup_script = templatefile("scripts/startup_agent.sh", {
    # controller_ip = google_compute_instance.vm_jenkins_controller.network_interface[0].access_config[0].nat_ip # nat_ip for external
    controller_ip = google_compute_instance.vm_jenkins_controller.network_interface[0].network_ip  # internal IP
    agent_name    = "agent-1"
    agent_secret  = var.jenkins_agent1_secret
  })

  depends_on = [google_compute_subnetwork.vpc_subnet_vm, google_compute_instance.vm_jenkins_controller]

}

# resource "google_compute_instance" "vm_fastapi_app" {
#   name         = var.app_server_name
#   machine_type = var.app_server_machine_type
#   zone         = var.zone

#   labels = {
#     environment = "development"
#     managed_by  = "terraform"
#     usecase     = "fastapi"
#   }

#   boot_disk {
#     initialize_params {
#       image = var.type_os_image
#       size  = 10
#     }
#   }

#   network_interface {
#     subnetwork = google_compute_subnetwork.vpc_subnet_vm.id

#     access_config {
#       # Ephemeral public IP
#     }
#   }

#   tags = [
#     tolist(google_compute_firewall.allow_ssh.target_tags)[0],
#     tolist(google_compute_firewall.allow_http.target_tags)[0]
#   ]
#   metadata = {
#     ssh-keys       = file("~/.ssh/id_rsa.pub")
#     startup-script = file("files/startup.sh")
#   }

#   depends_on = [google_compute_subnetwork.vpc_subnet_vm]
# }