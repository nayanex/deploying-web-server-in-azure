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


## VIRTUAL NETWORKING

The Azure documentation on [virtual networks](https://docs.microsoft.com/azure/virtual-network/manage-virtual-network?WT.mc_id=udacity_learn-wwl) is helpful, and also contains information on DNS, VNet peering, and more advanced virtual networking concepts.

Once we have a virtual network, we can create a subnets within it to separate resources. Subnetting is important both to reduce congestion and for security purposes

* We can have as many subnets as we have IP addresses, since two subnets can not contain the same IP address.

* Subnets contain VMs and Virtual Network Interface cards (NICs).

* Subnets and networks are separate from VMs, they can persist after a VM is gone.

### Network Interface Cards

* They're assigned a private IP address on the subnet correspondingly. Whatever virtual machine they are attached to resolves to that IP address.

* Must be in the same region as the VM is attached to.

### Public IP Address

* Allows access to a subnet from the internet - this can be scary. Without security, we have no way of restricting access from bad actors. Make sure you configure Security Groups.

* IP address assignment can be dynamic or static.A dynamic IP address gives us a public IP when the VM is started and is less expensive than a static IP address. you would want to use a static IP address when you want to map a certificate to an IP address or when we have a custom domain name for our IP

### NETWORK SECURITY GROUPS

* Rules to define what traffic can flow in and out of VMs.

* Associated to virtual network subnets



