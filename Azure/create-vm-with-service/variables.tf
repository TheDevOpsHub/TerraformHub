variable "env" {
  description = "The tag name of your VM"
  type        = string
  default     = "dev"
}

variable "prefix" {
  type        = string
  default     = "flatcar-vm"
  description = "Prefix of the resource name"
}

variable "admin_username" {
  type        = string
  default     = "azureadmin"
  description = "Admin username"
}

variable "resource_group_location" {
  type        = string
  default     = "eastus"
  description = "Location of the resource group."
}
