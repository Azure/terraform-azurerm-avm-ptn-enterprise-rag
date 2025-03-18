variable "virtual_network_create" {
  type        = bool
  default     = true
  description = "Indicates whether to create an existing Virtual Network."
}

variable "virtual_network_id" {
  type        = string
  default     = null
  description = "The ID of the existing Virtual Network."
}

variable "virtual_network_address_space" {
  type        = list(string)
  default     = ["10.0.0.0/23"]
  description = "The address space for the virtual network."
}

variable "virtual_network_subnets" {
  type = map(object({
    name        = string
    prefix_size = number
  }))
  default = {
    "01_ai" = {
      name        = "ai-subnet"
      prefix_size = 26
    }
    "02_bastion" = {
      name        = "AzureBastionSubnet"
      prefix_size = 26
    }
    "03_app_integration" = {
      name        = "app-integration-subnet"
      prefix_size = 26
    }
    "04_app_service" = {
      name        = "app-services-subnet"
      prefix_size = 26
    }
    "05_database" = {
      name        = "database-subnet"
      prefix_size = 26
    }
  }
}

variable "use_private_networking" {
  type        = bool
  default     = true
  description = "Indicates whether to use private networking."
}

variable "bastion_host_use" {
  type        = bool
  default     = true
  description = "Indicates whether to use a Bastion host."
}

variable "virtual_machine_use" {
  type        = bool
  default     = true
  description = "Indicates whether to use a virtual machine."
}
