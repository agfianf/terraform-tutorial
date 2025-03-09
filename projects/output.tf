# ------------------------------------------------------
# TERRAFORM OUTPUTS
# ------------------------------------------------------

# Output the ID of the created VPC 
output "vpc_id" {
  description = "The ID of the VPC"
  value       = google_compute_network.vpc_vm.id
}

# Output the name of created subnet
output "subnet_name" {
  description = "The name of the subnet"
  value       = google_compute_subnetwork.vpc_subnet_vm.name
}

# Output the names of all created VM instances
output "instance_names" {
  description = "Names of all created VM instances"
  value       = google_compute_instance.vm_instance[*].name
}

# Output the external IPs of all created VM instances
output "instance_external_ips" {
  description = "External IPs of all created VM instances"
  value       = [for i in google_compute_instance.vm_instance : i.network_interface[0].access_config[0].nat_ip]
}
