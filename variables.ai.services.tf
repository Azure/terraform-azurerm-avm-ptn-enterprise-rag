variable "azure_ai_services_create" {
  type        = bool
  default     = true
  description = "Create Azure AI Services resources"
}

variable "azure_ai_services_id" {
  type        = string
  default     = null
  description = "The ID of the Azure AI Services resource."
}

variable "ai_services_sku" {
  type        = string
  default     = "S0"
  description = "The SKU of the Azure AI Services resource."
}