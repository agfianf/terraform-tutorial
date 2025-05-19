variable "instance_type" {
  description = "Type of EC2 instance"
  type        = string
  default     = "t2.micro"
}

variable "ami_type" {
  description = "AMI Type"
  type        = string
  default     = "ami-01938df366ac2d954"
}

