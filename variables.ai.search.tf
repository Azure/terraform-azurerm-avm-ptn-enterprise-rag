variable "retrieval_approach" {
  description = "Orchestrator supports the following retrieval approaches: term, vector, hybrid(term + vector search), or use oyd feature of Azure OpenAI."
  type        = string
  default     = "hybrid"
}

variable "search_analyzer_name" {
  description = "Analyzer language used by Azure search to analyze indexes text content."
  type        = string
  default     = "standard"
}

variable "use_semantic_reranking" {
  description = "Use semantic reranking on top of search results?"
  type        = bool
  default     = false
}

variable "search_service_sku_name" {
  description = "Search service SKU name based on network isolation."
  type        = string
  default     = "standard2"
}

variable "search_index" {
  description = "Search index name."
  type        = string
  default     = "ragindex"
}

variable "search_api_version" {
  description = "Requires version 2023-10-01-Preview or higher for indexProjections and MIS authResourceId."
  type        = string
  default     = "2024-07-01"
}

variable "search_index_interval" {
  description = "Frequency of search reindexing. PT5M (5 min), PT1H (1 hour), P1D (1 day)."
  type        = string
  default     = "PT1H"
}

variable "search_use_mis" {
  description = "Use Search Service Managed Identity to Connect to data ingestion function?"
  type        = bool
  default     = false
}

variable "chunk_num_tokens" {
  description = "The number of tokens in each chunk."
  type        = string
  default     = "2048"
}

variable "chunk_min_size" {
  description = "The minimum chunk size below which chunks will be filtered."
  type        = string
  default     = "100"
}

variable "chunk_token_overlap" {
  description = "The number of tokens to overlap between chunks."
  type        = string
  default     = "200"
}
