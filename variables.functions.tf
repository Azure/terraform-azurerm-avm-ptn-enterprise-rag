# Orchestrator Function App Variables - https://github.com/Azure/GPT-RAG/blob/main/docs/GUIDE.md#orchestration-flow

variable "orchestrator_function_app_create" {
  type        = bool
  default     = true
  description = "Flag to create the Orchestrator Function App."
}

variable "orchestrator_function_app_id" {
  type        = string
  default     = null
  description = "The ID of the existing Orchestrator Function App."
}

variable "orchestrator_function_app_storage_account_create" {
  type        = bool
  default     = true
  description = "Flag to create the Orchestrator Function App Storage Account."
}

variable "orchestrator_function_app_storage_account_id" {
  type        = string
  default     = null
  description = "The ID of the existing Orchestrator Function App Storage Account."
}

variable "orchestrator_message_language" {
  type        = string
  default     = "en-US"
  description = "The language for the orchestrator message."
}

# Data Ingestion Function App Variables - https://github.com/Azure/GPT-RAG/blob/main/docs/GUIDE.md#data-ingestion

variable "data_ingestion_function_app_create" {
  type        = bool
  default     = true
  description = "Flag to create the Data Ingestion Function App."
}

variable "data_ingestion_function_app_id" {
  type        = string
  default     = null
  description = "The ID of the existing Data Ingestion Function App."
}

variable "data_ingestion_function_app_storage_account_create" {
  type        = bool
  default     = true
  description = "Flag to create the Data Ingestion Function App Storage Account."
}

variable "data_ingestion_function_app_storage_account_id" {
  type        = string
  default     = null
  description = "The ID of the existing Data Ingestion Function App Storage Account."
}