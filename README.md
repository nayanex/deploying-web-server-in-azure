# Azure Infrastructure Operations Project: Deploying a scalable IaaS web server in Azure

### Introduction
For this project, you will write a Packer template and a Terraform template to deploy a customizable, scalable web server in Azure.

### Getting Started
1. Clone this repository

2. Create your infrastructure as code

3. Update this README to reflect how someone would use your code.

### Dependencies
1. Create an [Azure Account](https://portal.azure.com) 
2. Install the [Azure command line interface](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
3. Install [Packer](https://www.packer.io/downloads)
4. Install [Terraform](https://www.terraform.io/downloads.html)

### Instructions

- Run `packer build`  on your Packer template with any appropriate variable arguments
- Run `terraform plan -out solution.plan`
- Deploy your Terraform infrastructure – don't forget to `terraform destroy` when done

### Output

We used Packer to create a server image, and Terraform to create a template for deploying a scalable cluster of servers—with a load balancer to manage the incoming traffic. We’ll also needed to adhere to security practices and ensure that our infrastructure is secure.

```bash
az policy definition create --name LinuxPasswordPolicy --rules azurepolicy.rules.json --description "Ensures all indexed resources in the subscription have tags and deny deployment if they do not."  --display-name "Ensures indexed resources in the subscription have tags"
az policy assignment create --policy LinuxPasswordPolicy
az policy assignment list
```
