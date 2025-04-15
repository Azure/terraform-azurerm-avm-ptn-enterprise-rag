# Calculate resource names
locals {
  name_replacements = {
    workload       = var.resource_name_workload
    environment    = var.resource_name_environment
    location       = var.location
    location_short = coalesce(var.resource_name_location_short, substr(var.location, 0, 3))
    uniqueness     = random_string.unique_name.id
    sequence       = format("%03d", var.resource_name_sequence_start)
  }

  resource_names = { for key, value in var.resource_name_templates : key => templatestring(value, local.name_replacements) }
}

# Resources
locals {
  resource_group_name = var.resource_group_create ? module.resource_group[0].name : var.resource_group_name

  # AI Search

  ai_search_id     = var.ai_search_create ? module.ai_search[0].resource_id : var.ai_search_id
  ai_search_parsed = provider::azurerm::parse_resource_id(local.ai_search_id)

  # AI Services

  ai_services_id     = var.azure_ai_services_create ? module.ai_services[0].resource_id : var.azure_ai_services_id
  ai_services_parsed = provider::azurerm::parse_resource_id(var.azure_ai_services_id)

  # App Service

  app_service_plan_id = var.app_service_plan_create ? module.app_service_plan[0].resource_id : var.app_service_plan_id
  app_service_id      = var.app_service_create ? module.web_app_frontend[0].resource_id : var.app_service_id

  # Bastion Host

  bastion_host_id = var.bastion_host_create ? module.bastion_host[0].resource_id : null

  # Cosmos DB

  cosmos_db_account_id     = var.cosmos_db_create ? module.cosmos_db[0].resource_id : var.cosmos_db_account_id
  cosmos_db_account_parsed = provider::azurerm::parse_resource_id(local.cosmos_db_account_id)
  cosmos_db_database_id    = var.cosmos_db_create ? module.cosmos_db[0].sql_databases["primary"].id : data.azurerm_cosmosdb_sql_database.existing[0].id

  # Function Apps

  orchestrator_function_app_id     = var.orchestrator_function_app_create ? module.orchestrator_function_app[0].resource_id : var.orchestrator_function_app_id
  orchestrator_function_app_parsed = provider::azurerm::parse_resource_id(local.orchestrator_function_app_id)

  orchestrator_function_app_storage_account_id     = var.orchestrator_function_app_storage_account_create ? module.orchestrator_fa_storage_account[0].resource_id : var.orchestrator_function_app_storage_account_id
  orchestrator_function_app_storage_account_parsed = provider::azurerm::parse_resource_id(local.orchestrator_function_app_storage_account_id)

  data_ingestion_function_app_id     = var.data_ingestion_function_app_create ? module.data_ingestion_function_app[0].resource_id : var.data_ingestion_function_app_id
  data_ingestion_function_app_parsed = provider::azurerm::parse_resource_id(local.data_ingestion_function_app_id)

  data_ingestion_function_app_storage_account_id     = var.data_ingestion_function_app_storage_account_create ? module.data_ingestion_fa_storage_account[0].resource_id : var.data_ingestion_function_app_storage_account_id
  data_ingestion_function_app_storage_account_parsed = provider::azurerm::parse_resource_id(local.data_ingestion_function_app_storage_account_id)

  # Key Vaults

  key_vault_id         = var.key_vault_create ? module.key_vault[0].resource_id : var.key_vault_id
  key_vault_parsed     = provider::azurerm::parse_resource_id(local.key_vault_id)
  key_vault_endpoint   = var.key_vault_create ? module.key_vault[0].vault_uri : data.azurerm_key_vault.key_vault.vault_uri
  kay_vault_bastion_id = var.key_vault_bastion_create ? module.key_vault_bastion[0].resource_id : var.key_vault_bastion_id

  # Logging

  application_insights_id                = var.application_insights_create ? module.application_insights[0].resource_id : var.application_insights_id
  application_insights_parsed            = provider::azurerm::parse_resource_id(local.application_insights_id)
  application_insights_key               = var.application_insights_create ? module.application_insights[0].instrumentation_key : data.azurerm_application_insights.existing[0].instrumentation_key
  application_insights_connection_string = var.application_insights_create ? module.application_insights[0].connection_string : data.azurerm_application_insights.existing[0].connection_string
  log_analytics_workspace_id             = var.log_analytics_workspace_create ? module.log_analytics_workspace[0].resource_id : var.log_analytics_workspace_resource_id

  # Networking

  virtual_network_id     = var.virtual_network_create ? module.virtual_network[0].resource_id : var.virtual_network_id
  virtual_network_parsed = provider::azurerm::parse_resource_id(local.virtual_network_id)

  # Open AI

  azure_open_ai_id     = var.azure_open_ai_create ? module.azure_open_ai[0].resource_id : var.azure_open_ai_id
  azure_open_ai_parsed = provider::azurerm::parse_resource_id(local.azure_open_ai_id)

  # Storage

  storage_account_id     = var.storage_account_create ? module.storage_account[0].resource_id : var.storage_account_id
  storage_account_parsed = provider::azurerm::parse_resource_id(var.storage_account_id).resource_name
}

locals {
  diagnostic_settings = {}
}

# My IP address
locals {
  my_ip_address_split = split(".", data.http.ip.response_body)
  my_cidr_slash_24    = "${join(".", slice(local.my_ip_address_split, 0, 3))}.0/24"
}
