variable "location" {
  type        = string
  description = "Azure region where the resource should be deployed."
  nullable    = false
}

variable "resource_name_location_short" {
  type        = string
  description = "Short name of the Azure region where the resource should be deployed. Will use the first 3 characters of the location if not supplied."
  default     = null
}

variable "resource_name_workload" {
  type        = string
  description = "The name segment for the workload"
  default     = "rag"
  validation {
    condition     = can(regex("^[a-z0-9]+$", var.resource_name_workload))
    error_message = "The name segment for the workload must only contain lowercase letters and numbers"
  }
  validation {
    condition     = length(var.resource_name_workload) <= 4
    error_message = "The name segment for the workload must be 4 characters or less"
  }
}

variable "resource_name_environment" {
  type        = string
  description = "The name segment for the environment"
  default     = "prod"
  validation {
    condition     = can(regex("^[a-z0-9]+$", var.resource_name_environment))
    error_message = "The name segment for the environment must only contain lowercase letters and numbers"
  }
  validation {
    condition     = length(var.resource_name_environment) <= 4
    error_message = "The name segment for the environment must be 4 characters or less"
  }
}

variable "resource_name_sequence_start" {
  type        = number
  description = "The number to use for the resource names"
  default     = 1
  validation {
    condition     = var.resource_name_sequence_start >= 1 && var.resource_name_sequence_start <= 999
    error_message = "The number must be between 1 and 999"
  }
}

variable "resource_name_templates" {
  type        = map(string)
  description = "A map of resource names to use"
  default = {
    resource_group_name                               = "rg-$${workload}-$${environment}-$${location}-$${sequence}"
    azure_open_ai_name                                = "oai-$${workload}-$${environment}-$${location}-$${sequence}"
    azure_open_ai_private_endpoint_name               = "pe-oai-$${workload}-$${environment}-$${location}-$${sequence}"
    application_insights_name                         = "ai-$${workload}-$${environment}-$${location}-$${sequence}"
    log_analytics_workspace_name                      = "law-$${workload}-$${environment}-$${location}-$${sequence}"
    app_service_plan_name                             = "asp-$${workload}-$${environment}-$${location}-$${sequence}"
    ai_search_name                                    = "aisrc-$${workload}-$${environment}-$${location}-$${sequence}"
    ai_search_private_endpoint_name                   = "pe-aisrc-$${workload}-$${environment}-$${location}-$${sequence}"
    azure_ai_services_name                            = "aiser-$${workload}-$${environment}-$${location}-$${sequence}"
    azure_ai_services_private_endpoint_name           = "pe-aiser-$${workload}-$${environment}-$${location}-$${sequence}"
    cosmos_db_name                                    = "cdb-$${workload}-$${environment}-$${location}-$${sequence}"
    cosmos_db_private_endpoint_name                   = "pe-cdb-$${workload}-$${environment}-$${location}-$${sequence}"
    cosmos_db_database_name                           = "db-$${workload}-$${environment}-$${location}-$${sequence}"
    cosmos_db_container_conversations_name            = "conversations"
    cosmos_db_container_datasources_name              = "datasources"
    key_vault_name                                    = "kv$${workload}$${environment}$${location_short}$${sequence}$${uniqueness}"
    key_vault_private_endpoint_name                   = "pe-kv-$${workload}-$${environment}-$${location}-$${sequence}"
    key_vault_bastion_name                            = "kvb$${workload}$${environment}$${location_short}$${sequence}$${uniqueness}"
    storage_account_name                              = "st$${workload}$${environment}$${location_short}$${sequence}$${uniqueness}"
    storage_account_private_endpoint_name             = "pe-st-$${workload}-$${environment}-$${location}-$${sequence}"
    load_testing_name                                 = "lt-$${workload}-$${environment}-$${location}-$${sequence}"
    virtual_network_name                              = "vnet-$${workload}-$${environment}-$${location}-$${sequence}"
    orchestrator_function_app_name                    = "fn-$${workload}-$${environment}-$${location}-$${sequence}"
    orchestrator_function_app_private_endpoint_name   = "pe-fn-orch-$${workload}-$${environment}-$${location}-$${sequence}"
    orchestrator_function_app_storage_account_name    = "st-fn-orch-$${workload}-$${environment}-$${location}-$${sequence}"
    data_ingestion_function_app_name                  = "fn-ingest-$${workload}-$${environment}-$${location}-$${sequence}"
    data_ingestion_function_app_private_endpoint_name = "pe-fn-ingest-$${workload}-$${environment}-$${location}-$${sequence}"
    data_ingestion_function_app_storage_account_name  = "st-fn-ingest-$${workload}-$${environment}-$${location}-$${sequence}"
    app_service_name                                  = "app-$${workload}-$${environment}-$${location}-$${sequence}"
    app_service_private_endpoint_name                 = "pe-app-$${workload}-$${environment}-$${location}-$${sequence}"
    virtual_machine_name                              = "vm-$${workload}-$${environment}-$${location}-$${sequence}"
    virtual_machine_computer_name                     = "vm$${workload}$${environment}$${location_short}$${sequence}"
    virtual_machine_network_interface_name            = "nic-$${workload}-$${environment}-$${location}-$${sequence}"
    bastion_host_name                                 = "bas-$${workload}-$${environment}-$${location}-$${sequence}"
    bastion_host_public_ip_name                       = "pip-bas-$${workload}-$${environment}-$${location}-$${sequence}"
    storage_account_container_documents_name          = "documents"
    storage_account_container_images_name             = "docuemnts-images"
    storage_account_container_nl2sql_name             = "nl2sql"
  }
}

variable "resource_group_name" {
  type        = string
  default     = null
  description = "The name of the existing resource group to use. Only required if `resource_group_create` is set to false."
}

variable "resource_group_create" {
  type        = bool
  default     = true
  description = "Indicates whether to create a new resource group."
}

variable "enable_telemetry" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module.
For more information see <https://aka.ms/avm/telemetryinfo>.
If it is set to false, then no telemetry will be collected.
DESCRIPTION
  nullable    = false
}

variable "role_assignments" {
  type = map(object({
    role_definition_id_or_name             = string
    principal_id                           = string
    description                            = optional(string, null)
    skip_service_principal_aad_check       = optional(bool, false)
    condition                              = optional(string, null)
    condition_version                      = optional(string, null)
    delegated_managed_identity_resource_id = optional(string, null)
  }))
  default     = {}
  description = <<DESCRIPTION
A map of role assignments to create on this resource. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `role_definition_id_or_name` - The ID or name of the role definition to assign to the principal.
- `principal_id` - The ID of the principal to assign the role to.
- `description` - The description of the role assignment.
- `skip_service_principal_aad_check` - If set to true, skips the Azure Active Directory check for the service principal in the tenant. Defaults to false.
- `condition` - The condition which will be used to scope the role assignment.
- `condition_version` - The version of the condition syntax. Valid values are '2.0'.

> Note: only set `skip_service_principal_aad_check` to true if you are assigning a role to a service principal.
DESCRIPTION
  nullable    = false
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "(Optional) Tags of the resource."
}
