variable "prefix" {
  description = "The prefix which should be used for all resources in this example"
  default     = "udacity"
}

variable "environment" {
  description = "Project Environment (dev/test/prod)"
  default     = "dev"
}

variable "project" {
  description = "Project Name"
  default     = "azure-web-server"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be created."
  default     = "westeurope"
}

variable "admin_username" {
  description = "VM username."
  default     = "adminuser"
}

variable "admin_password" {
  description = "The admin password for the VMs"
  default = ""
}

variable "address_space" {
  description = "VNet Address space"
  default     = "10.0.0.0/16"
}

variable "subnet_address" {
  description = "Subnet address space"
  default     = "10.0.0.0/24"
}

variable "number_of_vms" {
  description = "Number of VMs to provision"
  type        = number
  default     = 3
}

variable "image" {
  description = "Packer Generated Image Name"
  default     = "packer-image"
}

variable "packer_resource_group" {
  description = "Resource group of the Packer image"
  default     = "packer-rg"
}
