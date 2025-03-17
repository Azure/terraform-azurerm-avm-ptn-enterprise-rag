variable "virtual_machine_create" {
  type        = bool
  default     = true
  description = "Indicates whether to create a Virtual Machine."
}

variable "virtual_machine_sku" {
  type        = string
  default     = "Standard_B2s"
  description = "The SKU of the Virtual Machine."
}
