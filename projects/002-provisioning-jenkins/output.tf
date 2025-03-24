output "instance_name" {
  value = google_compute_instance.vm_jenkins_controller.name
}

output "instance_ip" {
  value = google_compute_instance.vm_jenkins_controller.network_interface[0].access_config[0].nat_ip
}

output "controller_ip" {
  value = google_compute_instance.vm_jenkins_controller.network_interface[0].access_config[0].nat_ip
}