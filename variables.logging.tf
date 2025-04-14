variable "log_analytics_workspace_create" {
  type        = bool
  default     = true
  description = "Indicates whether to create an existing Log Analytics Workspace."
}

variable "log_analytics_workspace_resource_id" {
  type        = string
  default     = null
  description = "The resource ID of the existing Log Analytics Workspace."
}

variable "log_analytics_workspace_sku" {
  type        = string
  default     = "PerGB2018"
  description = "The SKU of the Log Analytics Workspace."
}

variable "log_analytics_workspace_retention_in_days" {
  type        = number
  default     = 30
  description = "The retention period in days for the Log Analytics Workspace."
}

variable "application_insights_type" {
  type        = string
  default     = "web"
  description = "The type of Application Insights resource to create."
}

variable "application_insights_create" {
  type        = bool
  default     = true
  description = "Indicates whether to create an Application Insights resource."
}

variable "application_insights_id" {
  type        = string
  default     = null
  description = "The ID of the existing Application Insights resource."
}
