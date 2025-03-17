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

variable "application_insights_use" {
  type        = bool
  default     = true
  description = "Indicates whether to use Application Insights."
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
