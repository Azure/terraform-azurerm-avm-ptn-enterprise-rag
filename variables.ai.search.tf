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

variable "azure_ai_search_semantic_sku" {
  type        = string
  default     = "free"
  description = "Specifies the Semantic Search SKU which should be used for this Search Service. Possible values include `free` and `standard`."
}