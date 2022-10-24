variable "prefix" {
  description = "The prefix which should be used for all resources in this example"
}

variable "environment" {
  description = "Project Environment (dev/test/prod)"
  default = "dev"
}

variable "project" {
  description = "Project Name"
  default = "azure-web-server"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be created."
}

variable "username" {
  description = "VM username."
}

variable "password" {
  description = "VM password."
}

variable "address_space" {
  description = "VNet Address space"
  default     = "10.0.0.0/16"
}

variable "subnet_address" {
  description = "Subnet address space"
  default     = "10.0.0.0/24"
}
