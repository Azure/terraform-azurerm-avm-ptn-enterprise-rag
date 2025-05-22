variable "use_private_networking" {
  type        = bool
  default     = true
  description = "Indicates whether to use private networking for the resource."
}

# Subnet IDs for Private Endpoints. Only required if use_private_networking is set to true.

variable "app_services_subnet_id" {
  type        = string
  default     = null
  description = "The ID of the subnet for app services; required for network injection."

  validation {
    condition     = !(var.use_private_networking) || (var.app_services_subnet_id != null)
    error_message = "If use_private_networking is true, you must define the app services subnet ID."
  }
}

variable "ai_subnet_id" {
  type        = string
  default     = null
  description = "The ID of the subnet for the AI services; required for network injection."

  validation {
    condition     = !(var.use_private_networking) || (var.ai_subnet_id != null)
    error_message = "If use_private_networking is true, you must define the AI subnet ID."
  }
}

variable "database_subnet_id" {
  type        = string
  default     = null
  description = "The ID of the subnet for CosmoDB; required for network injection."

  validation {
    condition     = !(var.use_private_networking) || (var.database_subnet_id != null)
    error_message = "If use_private_networking is true, you must define the AI subnet ID."
  }
}

# Private DNS Zones for Name Resolution. Only required if use_private_networking is set to true.

variable "ai_search_private_dns_zone_create" {
  type        = bool
  default     = true
  description = "Flag to create Private DNS Zone for AI Search. If set to false, the resource will not be created."
  nullable    = false
}

variable "ai_search_private_dns_zone" {
  type = object({
    additional_virtual_network_links = optional(map(object({
      name               = string
      virtual_network_id = string
    })), {}) # If `var.ai_search_private_dns_create` is true, this will automatically link the zone to the virtual network where your var.ai_subnet_id is located. This should only be used for additional virtual networks that need to be linked.
    tags = optional(map(string), {})
  })
  description = "Private DNS Zone for AI Search to be created."
  default     = {}
}

variable "ai_search_private_dns_zone_id" {
  type        = string
  default     = null
  description = "The ID of the existing Private DNS Zones for AI Search. Only required if `ai_search_private_dns_create` is set to false."

  validation {
    condition     = var.ai_search_private_dns_create || (var.ai_search_private_dns_zone_id != null)
    error_message = "If ai_search_private_dns_create is false, you must provide an existing Private DNS Zone ID via var.ai_search_private_dns_zone_id."
  }
}

variable "ai_service_private_dns_zone_create" {
  type        = bool
  default     = true
  description = "Flag to create Private DNS Zone for AI Services. If set to false, the resource will not be created."
  nullable    = false
}

variable "ai_service_private_dns_zone" {
  type = object({
    additional_virtual_network_links = optional(map(object({
      name               = string
      virtual_network_id = string
    })), {}) # If `var.ai_service_private_dns_zone_create` is true, this will automatically link the zone to the virtual network where your var.ai_subnet_id is located. This should only be used for additional virtual networks that need to be linked.
    tags = optional(map(string), {})
  })
  description = "Private DNS Zone for AI Services to be created."
  default     = {}
}

variable "ai_service_private_dns_zone_id" {
  type        = string
  default     = null
  description = "The ID of the existing Private DNS Zones for AI Services. Only required if `ai_search_private_dns_create` is set to false."

  validation {
    condition     = var.ai_service_private_dns_zone_create || (var.ai_service_private_dns_zone_id != null)
    error_message = "If ai_service_private_dns_zone_create is false, you must provide an existing Private DNS Zone ID via var.ai_service_private_dns_zone_id."
  }
}
