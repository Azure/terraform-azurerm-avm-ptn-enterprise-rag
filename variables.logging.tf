variable "application_insights_create" {
  type        = bool
  default     = true
  description = "Flag to create Application Insights. If set to false, the resource will not be created."
  nullable    = false
}

variable "application_insights" {
  type        = any
  default     = {}
  description = "Application Insights resource to be created and linked to web and function apps created. For details concerning inputs, see "
  nullable    = false
}

variable "application_insights_id" {
  type        = string
  default     = null
  description = "The ID of the existing Application Insights to use. Only required if `application_insights_create` is set to false."
}

variable "log_analytics_workspace_create" {
  type        = bool
  default     = true
  description = "Flag to create Log Analytics Workspace. If set to false, the resource will not be created."
  nullable    = false
}

variable "log_analytics_workspace" {
  type        = any
  default     = {}
  description = "Log Analytics resource to be created for Application Insights. For details concerning inputs, see "
  nullable    = false
}

variable "log_analytics_workspace_id" {
  type        = string
  default     = null
  description = "The ID of the existing Log Analytics Workspace to use. Only required if `log_analytics_workspace_create` is set to false."

  validation {
    condition     = var.log_analytics_workspace_create || (var.log_analytics_workspace_id != null)
    error_message = "If log_analytics_workspace_create is false, you must provide an existing log_analytics_workspace_id."
  }
}
