variable "cosmos_db_create" {
  type        = bool
  default     = true
  description = "Indicates whether to create a Cosmos DB resource."
}

variable "cosmos_db_account_id" {
  type        = string
  default     = null
  description = "The ID of the existing Cosmos DB account."
}

variable "cosmos_db_database_name" {
  type        = string
  default     = null
  description = "The name of the existing Cosmos DB database."
}

variable "cosmos_db_zone_redundant" {
  description = "Specifies whether the Cosmos DB account should be zone redundant."
  type        = bool
  default     = true
}

variable "cosmos_db_automatic_failover_enabled" {
  description = "Specifies whether automatic failover is enabled for the Cosmos DB account."
  type        = bool
  default     = true
}

variable "cosmos_db_max_throughput" {
  description = "The maximum throughput for the Cosmos DB account in autoscale mode."
  type        = number
  default     = 1000
}

variable "cosmos_db_analytical_storage_ttl" {
  description = "The default time-to-live (TTL) for analytical storage in seconds."
  type        = number
  default     = -1
}

variable "cosmos_db_default_ttl" {
  description = "The default time-to-live (TTL) for items in the Cosmos DB container in seconds."
  type        = number
  default     = 86400
}
