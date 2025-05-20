variable "app_service_plan_create" {
  type        = bool
  default     = true
  description = "Flag to create App Service Plan. If set to false, the resource will not be created."
  nullable    = false
}

variable "app_service_plan" {
  type        = any
  default     = {}
  description = "App Service Plan to be created. For details concerning inputs, see https://registry.terraform.io/modules/Azure/avm-res-web-serverfarm/azurerm/0.4.0?tab=inputs."
  nullable    = false

}

variable "app_service_plan_id" {
  type        = string
  default     = null
  description = "The ID of the existing App Service Plan to use. Only required if `app_service_plan_create` is set to false."
}
