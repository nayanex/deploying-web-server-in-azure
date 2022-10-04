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

In general, we want to store the policy definition as a file, so that we get the advantages of version control and from there we'll want to run az policy definition command, which will deploy our policy definition. The following policy definition ensure that we can audit all Linux VMs with SSH password login enabled.

```bash
az policy definition create --name LinuxPasswordPolicy --rules azurepolicy.rules.json --description "Ensures all indexed resources in the subscription have tags and deny deployment if they do not."  --display-name "Ensures indexed resources in the subscription have tags"
```

Once our policy definition is deployed, we are going to need to set up a policy assignment using the command:

```bash
az policy assignment create --policy LinuxPasswordPolicy

# To verify that your policy has been correctly deployed and applied:
az policy assignment list
```

For help

```bash
az policy assignment create -h
```

CONCLUSION: We created our policy locally, deployed it and applied it using the command line.

## NETWORK SECURITY GROUPS

