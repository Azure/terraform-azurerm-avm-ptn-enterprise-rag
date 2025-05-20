# Document Storage Account used to store content used for grounding responses

variable "document_storage_account_create" {
  type        = bool
  default     = true
  description = "Flag to create Document Storage Account which is used to store content used for grounding responses. If set to false, the resource will not be created."
  nullable    = false
}

variable "document_storage_account" {
  type        = any
  default     = {}
  description = "Document Storage Account to be created. For details concerning inputs, see https://registry.terraform.io/modules/Azure/avm-res-storage-storageaccount/azurerm/0.5.0?tab=inputs."
  nullable    = false

  validation {
    condition     = !(var.use_private_networking) || (length(var.document_storage_account.private_endpoints) > 0)
    error_message = "If use_private_networking is true, you must define private endpoints."
  }
}

variable "document_storage_account_id" {
  type        = string
  default     = null
  description = "The ID of the existing Document Storage Account to use. Only required if `document_storage_account_create` is set to false."
}

# Function App Storage Accounts

variable "orchestrator_storage_account_create" {
  type        = bool
  default     = true
  description = "Flag to create Orchestrator Storage Account. If set to false, the resource will not be created."
  nullable    = false
}

variable "orchestrator_storage_account" {
  type        = any
  default     = {}
  description = "Orchestrator Storage Account to be created. For details concerning inputs, see https://registry.terraform.io/modules/Azure/avm-res-storage-storageaccount/azurerm/0.5.0?tab=inputs."
  nullable    = false

  validation {
    condition     = !(var.use_private_networking) || (length(var.orchestrator_storage_account.private_endpoints) > 0)
    error_message = "If use_private_networking is true, you must define private endpoints."
  }
}

variable "orchestrator_storage_account_id" {
  type        = string
  default     = null
  description = "The ID of the existing Orchestrator Storage Account to use. Only required if `orchestrator_storage_account_create` is set to false."
}

variable "data_ingestion_storage_account_create" {
  type        = bool
  default     = true
  description = "Flag to create Data Ingestion Storage Account. If set to false, the resource will not be created."
  nullable    = false
}

variable "data_ingestion_storage_account" {
  type        = any
  default     = {}
  description = "Data Ingestion Storage Account to be created. For details concerning inputs, see https://registry.terraform.io/modules/Azure/avm-res-storage-storageaccount/azurerm/0.5.0?tab=inputs."
  nullable    = false

  validation {
    condition     = !(var.use_private_networking) || (length(var.data_ingestion_storage_account.private_endpoints) > 0)
    error_message = "If use_private_networking is true, you must define private endpoints."
  }
}

variable "data_ingestion_storage_account_id" {
  type        = string
  default     = null
  description = "The ID of the existing Data Ingestion Storage Account to use. Only required if `data_ingestion_storage_account_create` is set to false."
}
