variable "azure_open_ai_create" {
  type        = bool
  default     = true
  description = "Flag to create Azure Open AI Services. If set to false, the resource will not be created."
  nullable    = false
}

variable "azure_open_ai" {
  type        = any
  default     = {}
  description = "Azure Open AI Service to be created. For details concerning inputs, see https://registry.terraform.io/modules/Azure/avm-res-cognitiveservices-account/azurerm/0.7.0?tab=inputs."
  nullable    = false

  validation {
    condition     = !(var.use_private_networking) || (length(var.azure_open_ai.private_endpoints) > 0)
    error_message = "If use_private_networking is true, you must define private endpoints."
  }
}

