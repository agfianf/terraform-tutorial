# Hands On Terraform  🚀


## Project 1
![prject-1](./assets/terraform-vm.png)


Hi! This a hands-on guide for you wanna learn how to use Terraform to manage your infrastructure. This guide will cover the following topics:
- Create a VM instance using Terraform.
- Configure a network and firewall rules.
- Output the details of the created VM instances.
- Use variables to manage configuration parameters.


## Project Structure 📂

```bash
└── 📁 projects/
    ├── 📁 files/
    │   ├── secret-access.json      # 🔑: Credentials file for accessing GCP.
    │   └── startup.sh              # 📜: Bash script to initialize the VM instances.
    ├── main.tf                     # 📄: Main configuration file for creating VM instances.
    ├── network.tf                  # 📄: Configures the network and firewall rules.
    ├── output.tf                   # 📄: Outputs from the Terraform execution.
    ├── providers.tf                # 📄: Specifies the required providers and their versions.
    ├── terraform.tfstate
    ├── terraform.tfstate.backup
    └── variables.tf                # 📄: Defines variables used in the Terraform scripts.
```

## Project 2 - Install Jenkins
![prject-2](./assets/jenkins-overview.png)

```bash
└── 002-provisioning-jenkins
    ├── main.tf
    ├── network.tf
    ├── output.tf
    ├── provider.tf
    ├── scripts
    ├── terraform.tfstate
    ├── terraform.tfstate.backup
    ├── terraform.tfvars
    └── variable.tf
```


## Reference:

- Install Jenkins: https://phoenixnap.com/kb/install-jenkins-ubuntu