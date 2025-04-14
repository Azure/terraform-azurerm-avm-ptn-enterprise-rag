variable "key_vault_create" {
  type        = bool
  default     = true
  description = "Indicates whether to create a Key Vault."
}

variable "key_vault_id" {
  type        = string
  default     = null
  description = "The ID of the existing Key Vault."
}

variable "key_vault_bastion_create" {
  type        = bool
  default     = true
  description = "Indicates whether to create a Key Vault for Bastion."
}

variable "key_vault_bastion_id" {
  type        = string
  default     = null
  description = "The ID of the existing Key Vault for Bastion to store Data Science VM generated password in; Bastion requires public network access to pull secrets."
}