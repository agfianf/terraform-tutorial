# --- ssh configuration ---

variable "ssh_public_key_path" {
  description = "Path to the SSH public key"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

# --- Provider Configuration ---
variable "project_id" {
  description = "Project ID for the GCP project"
  type        = string
  validation {
    condition     = length(var.project_id) > 0
    error_message = "Project ID must not be empty."
  }
}

variable "region" {
  description = "Region for the VM instance"
  type        = string
  default     = "asia-southeast1"
}

variable "zone" {
  description = "Zone for the VM instance"
  default     = "asia-southeast1-a"
  type        = string
}

# --- VM for GitLab ---
variable "gitlab_server_name" {
  description = "Name of the GitLab server VM instance"
  default     = "gitlab-server"
  type        = string
}

variable "gitlab_server_type_machine" {
  description = "Machine type for the GitLab server VM instance"
  # default = "e2-medium"
  default = "e2-standard-2"
  type    = string
}

variable "gitlab_server_disk_size" {
  description = "Disk size for the GitLab server VM instance"
  default     = 50
  type        = number
}

variable "type_os_image" {
  description = "OS image for the GitLab server VM instance"
  default     = "ubuntu-os-cloud/ubuntu-minimal-2404-lts-amd64"
  type        = string
}

# --- Network Configuration ---
variable "vpc_name" {
  description = "Name of the VPC network"
  default     = "gitlab-vpc"
  type        = string
}

variable "subnet_name" {
  description = "Name of the subnet"
  default     = "gitlab-subnet"
  type        = string
}

variable "subnet_ip_range" {
  description = "IP range for the subnet in CIDR notation"
  type        = string
  default     = "10.128.0.0/24"
}
