variable "storage_account_create" {
  type        = bool
  default     = true
  description = "Indicates whether to create a Storage account."
}

variable "storage_account_id" {
  type        = string
  default     = null
  description = "The ID of the existing Storage account."
}
