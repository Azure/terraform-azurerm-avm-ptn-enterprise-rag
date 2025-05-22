data "azurerm_client_config" "current" {}

data "http" "ip" {
  url = "https://api.ipify.org/"
  retry {
    attempts     = 5
    max_delay_ms = 1000
    min_delay_ms = 500
  }
}

# data "azurerm_subnet" "bastion" {
#   count = var.bastion_host_create ? 1 : 0

#   name                 = "AzureBastionSubnet"
#   virtual_network_name = local.virtual_network_parsed.resource_name
#   resource_group_name  = local.virtual_network_parsed.resource_group_name

#   depends_on = [module.virtual_network] # dynamically retrieves AzureBastionSubnet if created or using existing
# }

data "azurerm_search_service" "existing" {
  count = !var.ai_search.create ? 1 : 0

  name                = local.ai_search_parsed.resource_name
  resource_group_name = local.ai_search_parsed.resource_group_name
}

data "azurerm_cognitive_account" "existing" {
  count = !var.azure_open_ai_create ? 1 : 0

  name                = local.azure_open_ai_parsed.resource_name
  resource_group_name = local.azure_open_ai_parsed.resource_group_name
}

# data "azurerm_linux_function_app" "orchestrator" {
#   count = !var.orchestrator_function_app_create ? 1 : 0

#   name                = local.orchestrator_function_app_parsed.resource_name
#   resource_group_name = local.orchestrator_function_app_parsed.resource_group_name
# }

# data "azurerm_linux_function_app" "data_ingestion" {
#   count = !var.data_ingestion_function_app_create ? 1 : 0

#   name                = local.data_ingestion_function_app_parsed.resource_name
#   resource_group_name = local.data_ingestion_function_app_parsed.resource_group_name
# }

data "azurerm_key_vault" "existing" {
  count = !var.key_vault_create ? 1 : 0

  name                = local.key_vault_parsed.resource_name
  resource_group_name = local.key_vault_parsed.resource_group_name
}

# data "azurerm_application_insights" "existing" {
#   count = !var.application_insights_create ? 1 : 0

#   name                = local.application_insights_parsed.resource_name
#   resource_group_name = local.application_insights_parsed.resource_group_name
# }

# data "azurerm_cosmosdb_account" "existing" {
#   count = !var.cosmos_db_create ? 1 : 0

#   name                = local.cosmos_db_account_parsed.resource_name
#   resource_group_name = local.cosmos_db_account_parsed.resource_group_name
# }
