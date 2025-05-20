variable "ai_service_create" {
  type        = bool
  default     = true
  description = "Flag to create Azure AI Services. If set to false, the resource will not be created."
  nullable    = false
}

variable "ai_service" {
  type        = any
  default     = {}
  description = "Azure AI Service to be created. For details concerning inputs, see https://registry.terraform.io/modules/Azure/avm-res-cognitiveservices-account/azurerm/0.7.0?tab=inputs."
  nullable    = false

  validation {
    condition     = !(var.use_private_networking) || (length(var.ai_service.private_endpoints) > 0)
    error_message = "If use_private_networking is true, you must define private endpoints."
  }
}
