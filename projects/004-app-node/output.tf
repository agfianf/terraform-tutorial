output "fastapi_server_name" {
  description = "Name of the FastAPI server instance"
  value       = google_compute_instance.vm_fastapi_server.name
}

output "fastapi_server_external_ip" {
  description = "External IP of the FastAPI server"
  value       = google_compute_instance.vm_fastapi_server.network_interface[0].access_config[0].nat_ip
}

output "fastapi_server_internal_ip" {
  description = "Internal IP of the FastAPI server"
  value       = google_compute_instance.vm_fastapi_server.network_interface[0].network_ip
}

output "fastapi_url" {
  description = "URL to access the FastAPI application"
  value       = "http://${google_compute_instance.vm_fastapi_server.network_interface[0].access_config[0].nat_ip}"
}