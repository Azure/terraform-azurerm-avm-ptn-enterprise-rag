







variable "azure_ai_search_create" {
  type        = bool
  default     = true
  description = "Indicates whether to create an AI Search resource."
}

variable "azure_ai_search_id" {
  type        = string
  default     = null
  description = "The ID of the existing AI Search resource."
}

variable "azure_ai_services_create" {
  type        = bool
  default     = true
  description = "Indicates whether to create an AI Services resource."
}

variable "azure_ai_services_id" {
  type        = string
  default     = ""
  description = "The ID of the existing AI Services resource."
}



variable "key_vault_create" {
  type        = bool
  default     = true
  description = "Indicates whether to create a Key Vault."
}

variable "key_vault_id" {
  type        = string
  default     = null
  description = "The ID of the existing Key Vault."
}





variable "orchestrator_function_app_create" {
  type        = bool
  default     = true
  description = "Indicates whether to create an existing Orchestrator Function App."
}

variable "orchestrator_function_app_id" {
  type        = string
  default     = null
  description = "The ID of the existing Orchestrator Function App."
}

variable "data_ingestion_function_app_create" {
  type        = bool
  default     = true
  description = "Indicates whether to create the Data Ingestion Function App."
}

variable "data_ingestion_function_app_id" {
  type        = string
  default     = null
  description = "The ID of the existing Data Ingestion Function App."
}



variable "orchestrator_function_app_storage_create" {
  type        = bool
  default     = true
  description = "Indicates whether to create the Orchestrator Function App Storage."
}

variable "orchestrator_function_app_storage_account_id" {
  type        = string
  default     = null
  description = "The ID of the existing Orchestrator Function App Storage."
}


variable "data_ingestion_function_app_storage_create" {
  type        = bool
  default     = true
  description = "Indicates whether to create the Data Ingestion Function App Storage."
}

variable "data_ingestion_function_app_storage_account_id" {
  type        = string
  default     = null
  description = "The ID of the existing Data Ingestion Function App Storage."
}
