# FastAPI App Node on GCP with Terraform

This project provisions a VM for running a FastAPI application on Google Cloud Platform using Terraform. It sets up the network, firewall, and installs Docker and Docker Compose for containerized app deployment.

## Features
- Creates a custom VPC and subnet for the app
- Provisions a VM with Ubuntu 24.04 LTS
- Sets up firewall rules for HTTP (80) and SSH (22)
- Installs Docker and Docker Compose
- Outputs instance and app URL after provisioning

## Usage
1. Set your GCP credentials in `scripts/secret-access.json`.
2. Adjust variables in `variable.tf` as needed.
3. Run:
   ```bash
   terraform init
   terraform apply
   ```
4. Deploy your FastAPI app using Docker Compose on the provisioned VM.

## Files
- `main.tf`: VM and resource definitions
- `network.tf`: VPC, subnet, and firewall
- `variable.tf`: Input variables
- `provider.tf`: Provider config
- `scripts/startup_fastapi.sh`: Startup script for Docker setup

## Notes
- The output includes the external IP and app URL
- You can customize the startup script to deploy your FastAPI app
