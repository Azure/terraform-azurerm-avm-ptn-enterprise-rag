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
}

variable "key_vault_id" {
  type        = string
  default     = null
  description = "The ID of the existing Key Vault to use. Only required if `key_vault_create` is set to false."

  validation {
    condition     = var.key_vault_create || (var.key_vault_id != null)
    error_message = "If key_vault_create is false, you must provide an existing key_vault_id."
  }
}

variable "bastion_key_vault_create" {
  type        = bool
  default     = true
  description = "Flag to create Bastion Key Vault which stores password for the Data Science VM. If set to false, the resource will not be created."
  nullable    = false
}

variable "bastion_key_vault" {
  type        = any
  default     = {}
  description = "Bastion Key Vault resource to be created. For details concerning inputs, see https://registry.terraform.io/modules/Azure/avm-res-keyvault-vault/azurerm/0.9.1?tab=inputs."
  nullable    = false
}

variable "bastion_key_vault_id" {
  type        = string
  default     = null
  description = "The ID of the existing Bastion Key Vault to use. Only required if `bastion_key_vault_create` is set to false."

  validation {
    condition     = var.bastion_key_vault_create || (var.bastion_key_vault_id != null)
    error_message = "If bastion_key_vault_create is false, you must provide an existing bastion_key_vault_id."
  }
}
