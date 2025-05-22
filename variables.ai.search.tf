variable "ai_search_create" {
  type        = bool
  default     = true
  description = "Flag to create Azure AI Search which provides vector indexes for the retrieval. If set to false, the resource will not be created."
  nullable    = false
}

variable "ai_search" {
  type = object({
    allowed_ips = optional(list(string))
    authentication_failure_mode = optional(string, {
      aadOrApiKey = {
        aadAuthFailureMode = "http401WithBearerChallenge"
      }
    })
    customer_managed_key = optional(object({
      key_vault_resource_id = string
      key_name              = string
      key_version           = optional(string, null)
      user_assigned_identity = optional(object({
        resource_id = string
      }), null)
    }))
    customer_managed_key_enforcement_enabled = optional(bool)
    hosting_mode                             = optional(string, "default")
    local_authentication_enabled             = optional(bool, false)
    lock = optional(object({
      kind = string
      name = optional(string, null)
    }))
    partition_count = optional(number, 1)
    replica_count   = optional(number, 1)
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
    semantic_search_sku = optional(string, "free")
    sku                 = optional(string, "standard")
    tags                = optional(map(string), {})
  })
  default     = {}
  description = "Azure AI Search Service to be created. For details concerning inputs, see https://registry.terraform.io/modules/Azure/avm-res-search-searchservice/azurerm/0.1.5?tab=inputs."
  nullable    = false
}

variable "ai_search_id" {
  type        = string
  default     = null
  description = "The ID of the existing Azure AI Search. Only required if `ai_search_create` is set to false."

  validation {
    condition     = var.ai_search_create || (var.ai_search_id != null)
    error_message = "If ai_search_create is false, you must provide an existing ai_search_id."
  }
}

# variable "ai_search_analyzer_name" {
#   type        = string
#   default     = "standard"
#   description = "Analyzer language used by Azure search to analyze indexes text content."
# }

# variable "ai_search_api_version" {
#   type        = string
#   default     = "2024-07-01"
#   description = "The API version the funtion apps will use to access Azure AI Search"
# }

# variable "ai_search_index_name" {
#   type        = string
#   default     = "ragindex"
#   description = "AI Search Index Name"
# }

# variable "ai_search_index_interval" {
#   type        = string
#   default     = "PT1H"
#   description = "requency of search reindexing. PT5M (5 min), PT1H (1 hour), P1D (1 day)."
# }

# Chunking Settings

variable "document_intelligence_api_version" {
  type        = string
  default     = "2024-11-30"
  description = "The API version the function apps will use to access Document Intelligence."
}

variable "chunk_num_tokens" {
  type        = number
  default     = 2048
  description = "The number of tokens in each chunk."
}

variable "chunk_min_size" {
  type        = number
  default     = 100
  description = "The minimum chunk size below which chunks will be filtered."
}

variable "chunk_token_overlap" {
  type        = number
  default     = 200
  description = "The number of tokens to overlap between chunks."
}
