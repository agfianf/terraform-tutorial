# Self-hosted GitLab on GCP with Terraform

This project provisions a self-hosted GitLab instance on Google Cloud Platform using Terraform. It automates the creation of a VM, VPC, subnet, firewall rules, and installs GitLab CE using Docker Compose.

## Features
- Creates a dedicated VPC and subnet for GitLab
- Provisions a VM with Ubuntu 24.04 LTS
- Sets up firewall rules for HTTP (80), SSH (2222), and GitLab SSH (22)
- Installs Docker and Docker Compose
- Deploys GitLab CE using Docker Compose
- Outputs instance details after provisioning

## Usage
1. Set your GCP credentials in `scripts/secret-access.json`.
2. Adjust variables in `variable.tf` as needed.
3. Run:
   ```bash
   terraform init
   terraform apply
   ```
4. Access GitLab via the external IP output by Terraform.

## Files
- `main.tf`: VM and resource definitions
- `network.tf`: VPC, subnet, and firewall
- `variable.tf`: Input variables
- `provider.tf`: Provider config
- `scripts/startup_gitlab.sh`: Startup script for GitLab installation

## Notes
- SSH to the VM uses port 2222 (not default 22)
- Default GitLab URL: `http://<external-ip>`
- Check the VM logs for the initial root password
