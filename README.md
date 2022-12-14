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
- Run `terraform init` 
- Run `terraform plan -out solution.plan`
- Run `terraform apply "solution.plan"` or `terraform apply`
- Deploy your Terraform infrastructure – don't forget to `terraform destroy` when done

### Output

We used Packer to create a server image, and Terraform to create a template for deploying a scalable cluster of servers—with a load balancer to manage the incoming traffic. We’ll also needed to adhere to security practices and ensure that our infrastructure is secure.

In general, we want to store the policy definition as a file, so that we get the advantages of version control and from there we'll want to run az policy definition command, which will deploy our policy definition. The following policy definition ensure that we can audit all Linux VMs with SSH password login enabled.

```bash
az policy definition create --name LinuxPasswordPolicy --rules azurepolicy.rules.json --description "Ensures linux VMS are secured with password through SSH protocol"  --display-name "Ensures linux VMs are secured with ssh password"
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

## Create and Apply a Tagging Policy

```bash
# Ensures all indexed resources in the subscription have tags and deny deployment if they don't.
az policy definition create --name "TaggingPolicyDefinition" \
    --display-name "Ensures indexed resources in the subscription have tags" \
    --description "Ensures all indexed resources in the subscription have tags and deny deployment if they don't."  \
    --rules "tagging-policy.rules.json" \
    --mode "Indexed"
```

```bash
az policy assignment create --policy "TaggingPolicyDefinition" \
    --display-name "Ensures indexed resources in the subscription have tags" \
    --description "Ensures all indexed resources in the subscription have tags and deny deployment if they don't." \
    --name "tagging-policy"

# To verify that your policy has been correctly deployed and applied:
az policy assignment list
```

### Delete a resource policy assignment

[az polict assignment documentation](https://learn.microsoft.com/en-us/cli/azure/policy/assignment?view=azure-cli-latest)

```bash
az policy assignment delete --name "tagging-policy"

az policy assignment delete --name
                            [--resource-group]
                            [--scope]
```
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

## CIDR ip address subnet

https://www.freecodecamp.org/news/subnet-cheat-sheet-24-subnet-mask-30-26-27-29-and-other-ip-address-cidr-network-references/#:~:text=CIDR%20notation%20is%20really%20just,the%20subnet%20mask%20255.255.255.0%20.

https://docs.netgate.com/pfsense/en/latest/network/cidr.html

https://s3.amazonaws.com/tr-learncanvas/docs/IP_Filtering_in_Canvas.pdf

## SERVICE PRINCIPLE

* Requires an app registration, which is an identity configuration in the Azure AD tenant.
* This AD application resides in the registering tenant and is defined by one and only one application object even if it's a multi-tenant application
* Yes, service principles can have multi-tenant access, which is a powerful feature
* A Service Principle provides access on behalf of an application, you can use it instead of your account to create resources. This is great because it allows you to restrict access without restricting users. If you have an application which does one thing over and over, then it only needs a tiny set of permissions to perform that function. This is related to something covered in security best practices, the principle of least privilege. 

Tenants are organization-level, and typically are best thought of as "one per company" - that is, everyone with an `@microsoft.com` email would have an `@microsoft.com account` in the active directory tenant.

One option for managing Azure Active Directory is to use [Azure AD sync](https://docs.microsoft.com/azure/active-directory/hybrid/how-to-connect-sync-whatis?WT.mc_id=udacity_learn-wwl) to ensure that your on-premises active directory is the same as the one in the cloud. This can allow us to unify everything under one identity.

App developers may also use Azure AD to implement single sign on, as described in the [documentation](documentation).

Directories can have groups, which can be in other groups, each of which has numerous users. This allows inheritance of permissions. This is vital for permissions management and ensuring that permissions that are granted don't get "lost in the shuffle" by making management complicated.

### QUESTION

In Azure, an administrator has more privileges than a contributor, who has more permissions than a reader. Assume that your user is assigned the reader role. Your user is also in a subgroup of a group which is assigned the contributor role. What is the effective role assigned to your user?

- [ ] Administrator
- [x] Contributor
- [ ] Reader

## AZURE ACTIVE DIRECTORY

* Permissions for role-based access controls are covered under security groups
* You can add users or apps as members of an AAD group or **assign** permissions to the AAD group

### App Registrations

App registrations are a great way for us to use apps to perform a task. For example, if we want to create an app that allows us to give Terraform Access to create resources in our account.

Clicking on New Registration and following the proper steps will gve us:

- Application ID
- Tenant ID or Active Directory ID
- Object ID

We'll use the above to tell Azure what the application is and we can use it in coordination with Terraform to deploy our resources later on.

### Try it!

Now that you've seen Azure Active Directory, using the Azure Portal, you should go ahead and create a Service Principal for yourself, to use in future lessons.

- [ ] Navigate to Azure Active Directory in the Azure Portal
- [ ] Navigate to "App Registrations"
- [ ] Click "New Registration"
- [ ] Create a single tenant service principal with no redirect URI named "Terraform"
- [ ] Navigate to the "Subscriptions" service
- [ ] In your primary subscription, navigate to "Access control (IAM)"
- [ ] Click Add > Add role assignment
- [ ] Give the "Contributor" role to your "Terraform" application
- [ ] Click Save

### QUIZ

We created a single tenant application. When would you want to create a multi-tenant application?

- [ ] In a single company with many stores
- [ ] In an organization with a small IT department
- [X] When we have an application we want to authenticate to from another tenant
- [ ] When creating an application with a lot of users.


```bash
az account list
az vm -h
az vm list
az vm list -o table
az vm list -h
az vm create -h
az vm show -name udacity-cli-vm -resource-group udacity-cli-rg

## create resource group
az group create --name udacity-cli-rg --location eastus

## create virtual machine
az vm create --resource-group udacity-cli-rg --name udacity-cli-vm --image UbuntuLTS --generate-ssh-keys --output json --verbose
```

The command to create a virtual machine above will let us see the IP address that was created. We will also use an SSH key, so that we can use it in the command line to access the virtual machine.

```bash
ssh 52.152.216.174
```

While logged into the virtual machine you can ude the `iconfig` command to see the IP address and you can see that we have an internal IP address of 10.0.0.4, which is the first virtual IP address that can be assigned.

### NETWORK SECURITY GROUPS

* Rules to define what traffic can flow in and out of VMs.

* Associated to virtual network subnets

The default NSG allow internal traffic from the virtual network and any inbound traffic from a load balancer on the subnet and denies all other inbound traffic.

When you create NSGs, there are numerous customizations you can make, as follows, that allow you to really control your traffic in both directions.:

* Name
* Priority
* Source or Destination
* Protocol
* Direction
* Port Range
* Allow or Deny Action


Look at the default rules again. What services, if any, are now allowed or disallowed given the new "Allow RDP rule"?

![network-security-group-configuration](img/network-security-group-configuration.png)

The rule you added is lower priority, so it could explicitly allow RDP if a rule were put in place which might deny it, but nothing about the effective configuration changed.

Think about NSG rule evaluation order. Lower-numbers are evaluated first and evaluation stops as soon as a rule evaluates to true.

![allowRDP-NSG-inbound-rule](img/allowRDP-NSG-inbound-rule.png)

![deny-ssh-nsg-inbound-rule](img/deny-ssh-nsg-inbound-rule.png)

![Inbound-security-rules](img/Inbound-security-rules.png)


## Azure Security Best Practices

[Best Practices](https://docs.microsoft.com/azure/security/fundamentals/best-practices-and-patterns?WT.mc_id=udacity_learn-wwl)

### Treat Identity as the Perimeter

Using identity as your perimeter is a critical concept in cloud security. We should:

* Centralize identity management in Active Directory and implement [AD sync](https://docs.microsoft.com/azure/active-directory/hybrid/how-to-connect-sync-whatis?WT.mc_id=udacity_learn-wwl) if possible.
* Use s[ingle sign-on](https://docs.microsoft.com/azure/active-directory/manage-apps/what-is-application-management?WT.mc_id=udacity_learn-wwl) for apps that we manage to allow Azure AD to control access.

### Network Security

* Use strong network controls
* Segment subnets logically
* Have big virtual networks with small subnets
* Don't assign NSG rules with broad ranges
* Use [Just-in-Time VM](https://docs.microsoft.com/azure/security-center/just-in-time-explained?WT.mc_id=udacity_learn-wwl) access if possible

### Microsoft Learn


* [Configure and manage secrets in Azure Key Vault](https://docs.microsoft.com/learn/modules/configure-and-manage-azure-key-vault/?WT.mc_id=udacity_learn-wwl)
* [Monitor and report on security events in Azure AD](https://docs.microsoft.com/learn/modules/monitor-report-aad-security-events/?WT.mc_id=udacity_learn-wwl)
* [Improve your reliability with modern operations practices: Learning from failure](https://docs.microsoft.com/learn/modules/improve-reliability-failure/?WT.mc_id=udacity_learn-wwl)

## INFRASTRUCTURE AS CODE

**Infrastructure as code** gives us a huge advantage in defining, deploying, updating, and destroying our infrastructure. Some key benefits are:

* Instead of having to request development environments and wait for tickets to be fulfilled, we can use _self-service_ to allow users to deploy their own environments.
* Version control
* Increased documentation
* Automated testing and validation.

## Terraform

[Terraform documentation for Azure](https://www.terraform.io/docs/providers/azurerm/index.html)

### Deploying Resources with Terraform

Here, we create a Terraform configuration. To deploy our configuration, we run the following commands:

`terraform init`

`terraform plan -out <filename>`

`terraform apply` => Deploy your terraform infrastructure

`terraform show` =>  to see your new infrastructure!

`terraform destroy` => to take down your infrastructure

`terraform show` => To verify that everything has been destroyed.

[azurerm_public_ip Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip)

## Packer

```bash
packer build server.json

# display all of our virtual machine images
az image list 

# Remember, Packer does not maintain state, so you can't actually delete your Packer image using Packer
# So, for that you'll need to use Azure CLI command:
az image delete -g packer-rg -n packer-image

az image list
```

**OBS:** *Please create a resource groupe named* `packer-rg` before doing the steps above.

## AAD Service Principal Information


![AAD-service-principal-overview](img/AAD-service-principal-overview.png)


Fields |	Credentials	 | FROM
-------|-----------------|---------------
Application (Client) Id |	ee931dc3-e1ed-401f-b886-a8d83125124e | Application
Display Name	| terraform	|
Secret Key |	Ua38Q~hYCZz.IOYdLEgwU0~8CGfpYsi5Vo3_LaAj	| Value in Certificates and secrets (Application)
Subscription Id	| bb272072-9c6d-4e28-b814-947814c3e6ef	|
Tenant Id	| d6ce14d5-a0a4-4d36-b8b3-65222befc0b6	|
Tenant Domain Name	| api://ee931dc3-e1ed-401f-b886-a8d83125124e	| From Application ID URI (base URL)


![AAD-service-principal-expose-API](img/AAD-service-principal-expose-API.png)

## Set Environment Variables

```bash
source set_azure_env.sh 
# or 

. set_azure_env.sh
```