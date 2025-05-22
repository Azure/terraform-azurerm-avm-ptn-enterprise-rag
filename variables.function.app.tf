variable "orchestrator_function_app_create" {
  type        = bool
  default     = true
  description = "Flag to create Orchestrator Function App. If set to false, the resource will not be created."
  nullable    = false
}

variable "orchestrator_function_app" {
  type        = any
  default     = {}
  description = "Orchestrator Function App to be created. For details concerning inputs, see https://registry.terraform.io/modules/Azure/avm-res-web-site/azurerm/latest?tab=inputs."
  nullable    = false
}

variable "orchestrator_function_app_id" {
  type        = string
  default     = null
  description = "The ID of the existing Orchestrator Function App. Only required if `orchestrator_function_app_create` is set to false."

  validation {
    condition     = var.orchestrator_function_app_create || (var.orchestrator_function_app_id != null)
    error_message = "If orchestrator_function_app_create is false, you must provide an existing orchestrator_function_app_id."
  }
}

variable "data_ingestion_function_app_create" {
  type        = bool
  default     = true
  description = "Flag to create Data Ingestion Function App. If set to false, the resource will not be created."
  nullable    = false
}

variable "data_ingestion_function_app" {
  type        = any
  default     = {}
  description = "Data Ingestion Function App to be created. For details concerning inputs, see https://registry.terraform.io/modules/Azure/avm-res-web-site/azurerm/latest?tab=inputs."
  nullable    = false
}


variable "data_ingestion_function_app_id" {
  type        = string
  default     = null
  description = "The ID of the existing Data Ingestion Function App. Only required if `data_ingestion_function_app_create` is set to false."

  validation {
    condition     = var.data_ingestion_function_app_create || (var.data_ingestion_function_app_id != null)
    error_message = "If data_ingestion_function_app_create is false, you must provide an existing data_ingestion_function_app_id."
  }
}
