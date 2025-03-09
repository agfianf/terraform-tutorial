# -- Provider
variable "project_id" {
    description = "Project ID for the GCP project"
    default     = "steady-circuit-452708-i7"
}

variable "region" {
    description = "Region for the VM instance"
    default     = "asia-southeast1"
  
}

variable "zone" {
    description = "Zone for the VM instance"
    default     = "asia-southeast1-a"
}

# -- VM Instance

variable "instance_name" {
    description = "Name of the VM instance"
    default = "server"
}

variable "machine_type" {
    description = "Tipe mesin untuk VM"
    default     = "e2-micro"  # can do vertical scaling
}

variable "instance_count" {
    description = "Count of VM instances to create"
    type = number
    default = 1  # can do horizontal scaling
}

variable "type_os_image" {
    description = "Tipe OS image untuk VM"
    default     = "ubuntu-os-cloud/ubuntu-minimal-2404-lts-amd64"
}

# VPC
variable "vpc_name" {
    description = "Name of the VPC"
    default = "vpc-wakanda"
}

variable "subnet_name" {
    description = "Name of the subnet"
    default = "vpc-wakanda-subnet"
}

variable "subnet_ip_range" {
    description = "IP range for the subnet"
    default = "10.128.0.0/20"
  
}