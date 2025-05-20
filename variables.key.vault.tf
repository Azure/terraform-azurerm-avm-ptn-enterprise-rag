variable "key_vault_create" {
  type        = bool
  default     = true
  description = "Flag to create Key Vault which stores API keys when needed. If set to false, the resource will not be created."
  nullable    = false
}

variable "key_vault" {
  type        = any
  default     = {}
  description = "Key Vault resource to be created. For details concerning inputs, see https://registry.terraform.io/modules/Azure/avm-res-keyvault-vault/azurerm/0.9.1?tab=inputs."
  nullable    = false

  validation {
    condition     = !(var.use_private_networking) || (length(var.key_vault.private_endpoints) > 0)
    error_message = "If use_private_networking is true, you must define private endpoints."
  }
}

variable "key_vault_id" {
  type        = string
  default     = null
  description = "The ID of the existing Key Vault to use. Only required if `key_vault_create` is set to false."
}
