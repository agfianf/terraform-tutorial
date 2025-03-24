# -- Provider
variable "project_id" {
  description = "Project ID for the GCP project"
  type        = string
}

variable "region" {
  description = "Region for the VM instance"
  default     = "asia-southeast1"
  type        = string
}

variable "zone" {
  description = "Zone for the VM instance"
  default     = "asia-southeast1-a"
  type        = string
}


# -- VM for Jenkins Controller  
variable "jenkins_controller_name" {
  description = "Name of the Jenkins controller VM instance"
  default     = "jenkins-controller"
  type        = string
}

variable "jenkins_controller_type_machine" {
  description = "Machine type for the Jenkins controller VM instance"
  default     = "e2-medium"
  type        = string
}

# -- VM for Jenkins Agent
variable "jenkins_agent_name" {
  description = "Name of the Jenkins agent VM instance"
  default     = "jenkins-agent"
  type        = string
}

variable "jenkins_agent_type_machine" {
  description = "Machine type for the Jenkins agent VM instance"
  default     = "e2-small"
  type        = string
}

variable "jenkins_agent_count" {
  description = "Number of Jenkins agent VM instances"
  default     = 1
  type        = number
}

variable "jenkins_agent1_secret" {
  description = "Secret for the Jenkins agent"
  type        = string
  sensitive   = true
}

# -- VM for FastAPI application
variable "app_server_name" {
  description = "Name of the FastAPI application server VM instance"
  default     = "fastapi-server"
  type        = string
}

variable "app_server_machine_type" {
  description = "Machine type for the FastAPI application server VM instance"
  default     = "e2-small"
  type        = string

}

# -- Common VM Settings
variable "type_os_image" {
  description = "Type OS image for VM"
  default     = "ubuntu-os-cloud/ubuntu-minimal-2404-lts-amd64"
  type        = string
}

# -- Network
variable "vpc_name" {
  description = "Name of the VPC"
  default     = "vpc-jenkins-project"
  type        = string
}

variable "subnet_name" {
  description = "Name of the subnet"
  default     = "vpc-jenkins-project-subnet"
  type        = string
}

variable "subnet_ip_range" {
  description = "IP range for the subnet"
  default     = "10.128.0.0/20"
}