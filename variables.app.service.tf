variable "app_service_plan_create" {
  type        = bool
  default     = true
  description = "Indicates whether to create an App Service Plan."
}

variable "app_service_plan_id" {
  type        = string
  default     = ""
  description = "The ID of the existing App Service Plan."
}

variable "app_service_plan_sku_name" {
  type        = string
  default     = "P0v3"
  description = "The SKU name for the App Service Plan."
}

variable "app_service_plan_capacity" {
  type        = number
  default     = 1
  description = "The number of workers for the App Service Plan."
}

variable "app_service_create" {
  type        = bool
  default     = true
  description = "Indicates whether to create an existing App Service."
}

variable "app_service_id" {
  type        = string
  default     = ""
  description = "The ID of the existing App Service."
}

variable "app_service_runtime_version" {
  type        = string
  default     = "3.12"
  description = "The Python runtime version for the App Service."
}
