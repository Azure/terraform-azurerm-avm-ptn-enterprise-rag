variable "cosmos_db_create" {
  type        = bool
  default     = true
  description = "Indicates whether to create a new Cosmos DB account."
}

variable "cosmos_db_id" {
  type        = string
  default     = null
  description = "The ID of the existing Cosmos DB account to use. Only required if `cosmos_db_create` is set to false."

  validation {
    condition     = !(var.cosmos_db_create) || (var.cosmos_db_id != null)
    error_message = "If cosmos_db_create is false, you must define the cosmos_db_id."
  }
}