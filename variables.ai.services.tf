variable "ai_service_create" {
  type        = bool
  default     = true
  description = "Flag to create Azure AI Services. If set to false, the resource will not be created."
  nullable    = false
}

variable "ai_service" {
  type = object({
    sku = optional(string, "S0")
    network_acls = optional(object({
      default_action = string
      ip_rules       = optional(set(string))
      virtual_network_rules = optional(set(object({
        ignore_missing_vnet_service_endpoint = optional(bool)
        subnet_id                            = string
      })))
      bypass = optional(string)
    }))
    custom_subdomain_name = optional(string)
    customer_managed_key = optional(object({
      key_vault_resource_id = string
      key_name              = string
      key_version           = optional(string, null)
      user_assigned_identity = optional(object({
        resource_id = string
      }), null)
    }))
    dynamic_throttling_enabled = optional(bool)
    fqdns                      = optional(list(string))
    is_hsm_key                 = optional(bool)
    managed_identities = optional(object({
      system_assigned            = optional(bool, false)
      user_assigned_resource_ids = optional(set(string), [])
    }))
    lock = optional(object({
      kind = string
      name = optional(string, null)
    }))
    local_authentication_enabled = optional(bool, false)
    role_assignments = optional(map(object({
      role_definition_id_or_name             = string
      principal_id                           = string
      description                            = optional(string, null)
      skip_service_principal_aad_check       = optional(bool, false)
      condition                              = optional(string, null)
      condition_version                      = optional(string, null)
      delegated_managed_identity_resource_id = optional(string, null)
      principal_type                         = optional(string, null)
    })))
    tags = optional(map(string), {})
  })
  default     = {}
  description = "Azure AI Service to be created. For details concerning inputs, see https://registry.terraform.io/modules/Azure/avm-res-cognitiveservices-account/azurerm/0.7.0?tab=inputs."
  nullable    = false
}

variable "ai_service_id" {
  type        = string
  default     = null
  description = "The ID of the existing Azure AI Service. Only required if `ai_service_create` is set to false."

  validation {
    condition     = var.ai_service_create || (var.ai_service_id != null)
    error_message = "If ai_service_create is false, you must provide an existing ai_service_id."
  }
}
