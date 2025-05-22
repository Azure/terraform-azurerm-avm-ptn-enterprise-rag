variable "app_service_plan_create" {
  type        = bool
  default     = true
  description = "Flag to create App Service Plan. If set to false, the resource will not be created."
  nullable    = false
}

variable "app_service_plan" {
  type = object({
    lock = optional(object({
      kind = string
      name = optional(string, null)
    }))
    maximum_elastic_worker_count = optional(number)
    per_site_scaling_enabled     = optional(bool, false)
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
    sku                    = optional(string, "P0v3")
    worker_count           = optional(number, 1)
    zone_balancing_enabled = optional(bool, true)
    tags                   = optional(map(string), {})
  })
  default     = {}
  description = "App Service Plan to be created which hosts the front end and both functions apps; orchestrator and data ingestion"
  nullable    = false
}

variable "app_service_plan_id" {
  type        = string
  default     = null
  description = "The ID of the existing App Service Plan to use. Only required if `var.app_service_plan_create` is set to false."

  validation {
    condition     = var.app_service_plan_create || (var.app_service_plan_id != null)
    error_message = "If app_service_plan_create is false, you must provide an existing app_service_plan_id."
  }
}

variable "app_service_create" {
  type        = bool
  default     = true
  description = "Flag to create App Service. If set to false, the resource will not be created."
  nullable    = false
}

variable "app_service" {
  type        = any
  default     = {}
  description = "App Service to be created. For details concerning inputs, see https://registry.terraform.io/modules/Azure/avm-res-web-site/azurerm/0.16.4?tab=inputs."
  nullable    = false
}

variable "app_service_id" {
  type        = string
  default     = null
  description = "The ID of the existing App Service to use. Only required if `app_service_create` is set to false."

  validation {
    condition     = var.app_service_create || (var.app_service_id != null)
    error_message = "If app_service_create is false, you must provide an existing app_service_id."
  }
}
