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

variable "azure_ai_search_partition_count" {
  type        = number
  default     = 1
  description = "Partitions allow for scaling of document count as well as faster indexing by sharding your index over multiple search units."
}

variable "azure_ai_search_replica_count" {
  type        = number
  default     = 1
  description = "Replicas distribute search workloads across the service. You need at least two replicas to support high availability of query workloads (not applicable to the free tier)."
}

variable "azure_ai_search_local_auth_enabled" {
  description = "Enable local authentication for the Azure AI Search Service."
  type        = bool
  default     = false
}

variable "azure_ai_search_hosting_mode" {
  type        = string
  default     = "default"
  description = "Specifies the Hosting Mode, which allows for High Density partitions (that allow for up to 1000 indexes) should be supported. Possible values are `highDensity` or `default`. Defaults to `default`. Changing this forces a new Search Service to be created."
}

variable "authentication_failure_mode" {
  type        = string
  default     = "http401WithBearerChallenge"
  description = "Specifies the response that the Search Service should return for requests that fail authentication. Possible values include http401WithBearerChallenge or http403. Defaults to http401WithBearerChallenge."
}

variable "azure_ai_search_sku_name" {
  description = "Search service SKU name based on network isolation."
  type        = string
  default     = "standard2"
}

variable "azure_ai_search_cmk_enforcement_enabled" {
  type        = bool
  default     = false
  description = "Specifies whether the Search Service should enforce that non-customer resources are encrypted. Defaults to `false`."
}

variable "azure_ai_search_retrieval_approach" {
  type        = string
  default     = "hybrid"
  description = "Orchestrator supports the following retrieval approaches: term, vector, hybrid(term + vector search), or use oyd feature of Azure OpenAI."
}

variable "azure_ai_search_analyzer_name" {
  type        = string
  default     = "standard"
  description = "Analyzer language used by Azure search to analyze indexes text content."
}

variable "azure_ai_search_api_version" {
  type        = string
  default     = "2024-07-01"
  description = "The API version the funtion apps will use to access Azure AI Search"
}

variable "azure_ai_search_index_name" {
  type        = string
  default     = "ragindex"
  description = "AI Search Index Name"
}

variable "azure_ai_search_index_interval" {
  type        = string
  default     = "PT1H"
  description = "requency of search reindexing. PT5M (5 min), PT1H (1 hour), P1D (1 day)."
}

variable "use_semantic_reranking" {
  type        = bool
  default     = false
  description = "Use semantic reranking on top of search results?."
}