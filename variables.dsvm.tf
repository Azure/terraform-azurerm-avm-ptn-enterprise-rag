variable "data_science_vm_create" {
  type        = bool
  default     = true
  description = "Flag to create Data Science VM. If set to false, the resource will not be created."
  nullable    = false
}

variable "data_science_vm" {
  type        = any
  default     = null
  description = "Data Science VM to be created. For details concerning inputs, see https://registry.terraform.io/modules/Azure/avm-res-compute-virtualmachine/azurerm/0.18.0?tab=inputs."
}