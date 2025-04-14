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

variable "orchestrator_message_language" {
  type        = string
  default     = "en-US"
  description = "The language for the orchestrator message."
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
