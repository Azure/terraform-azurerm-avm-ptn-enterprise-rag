variable "ai_search_create" {
  type        = bool
  default     = true
  description = "Flag to create Azure AI Search which provides vector indexes for the retrieval. If set to false, the resource will not be created."
  nullable    = false
}

variable "ai_search" {
  type        = any
  default     = {}
  description = "Azure AI Search Service to be created. For details concerning inputs, see https://registry.terraform.io/modules/Azure/avm-res-search-searchservice/azurerm/0.1.5?tab=inputs."
  nullable    = false

  validation {
    condition     = !(var.use_private_networking) || (length(var.ai_search.private_endpoints) > 0)
    error_message = "If use_private_networking is true, you must define private endpoints."
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
