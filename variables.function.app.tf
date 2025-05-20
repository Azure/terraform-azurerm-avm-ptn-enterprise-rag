variable "orchestrator_function_app_create" {
  type        = bool
  default     = false
  description = "Flag to create Orchestrator Function App. If set to false, the resource will not be created."
  nullable    = false
}

variable "orchestrator_function_app" {
  type        = any
  default     = {}
  description = "Orchestrator Function App to be created. For details concerning inputs, see https://registry.terraform.io/modules/Azure/avm-ptn-function-app-storage-private-endpoints/azurerm/0.1.0?tab=inputs."
  nullable    = false
}

variable "data_ingestion_function_app_create" {
  type        = bool
  default     = false
  description = "Flag to create Data Ingestion Function App. If set to false, the resource will not be created."
  nullable    = false
}

variable "data_ingestion_function_app" {
  type        = any
  default     = {}
  description = "Data Ingestion Function App to be created. For details concerning inputs, see https://registry.terraform.io/modules/Azure/avm-ptn-function-app-storage-private-endpoints/azurerm/0.1.0?tab=inputs."
  nullable    = false
}
