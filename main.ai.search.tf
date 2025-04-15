module "private_dns_zone_ai_search" {
  count = var.use_private_networking && var.virtual_network_create ? 1 : 0

  source  = "Azure/avm-res-network-privatednszone/azurerm"
  version = "0.3.2"

  resource_group_name = local.resource_group_name
  domain_name         = "privatelink.search.azure.net"

  virtual_network_links = {
    primary = {
      vnetlinkname = "ai-search"
      vnetid       = local.virtual_network_id
    }
  }

  tags             = var.tags
  enable_telemetry = var.enable_telemetry
}

module "ai_search" {
  count   = var.ai_search_create ? 1 : 0
  source  = "Azure/avm-res-search-searchservice/azurerm"
  version = "0.1.5"

  name                                     = local.resource_names.ai_search_name
  location                                 = var.location
  resource_group_name                      = local.resource_group_name
  sku                                      = var.ai_search_sku_name
  partition_count                          = var.ai_search_partition_count
  replica_count                            = var.ai_search_replica_count
  customer_managed_key_enforcement_enabled = var.ai_search_cmk_enforcement_enabled
  hosting_mode                             = var.ai_search_hosting_mode
  public_network_access_enabled            = !var.use_private_networking
  local_authentication_enabled             = var.ai_search_local_auth_enabled
  authentication_failure_mode              = var.authentication_failure_mode
  semantic_search_sku                      = var.use_semantic_reranking ? "free" : "disabled"
  tags                                     = var.tags
  enable_telemetry                         = var.enable_telemetry

  managed_identities = {
    system_assigned = true
  }

  private_endpoints = var.use_private_networking ? {
    primary = {
      name                          = local.resource_names.ai_search_private_endpoint_name
      private_dns_zone_resource_ids = var.use_private_networking && var.virtual_network_create ? [module.private_dns_zone_ai_search[0].resource_id] : []
      subnet_resource_id            = module.virtual_network[0].subnets["01_ai"].resource_id # What if we are not creating virtual networks?
      subresource_name              = "searchService"
      tags                          = var.tags
    }
  } : null
}

resource "azurerm_role_assignment" "ai_search_storage_access" {
  scope                = local.storage_account_id
  principal_id         = var.ai_search_create ? module.ai_search[0].identity[0].principal_id : data.azurerm_search_service.existing[0].identity[0].principal_id
  role_definition_name = "Storage Blob Data Contributor"
}

resource "azurerm_role_assignment" "ai_search_open_ai_access" {
  scope                = local.azure_open_ai_id
  principal_id         = var.ai_search_create ? module.ai_search[0].identity[0].principal_id : data.azurerm_search_service.existing[0].identity[0].principal_id
  role_definition_name = "Cognitive Services OpenAI User"
}

resource "azurerm_key_vault_secret" "ai_search_key" {
  key_vault_id = local.key_vault_id
  name         = "azureSearchKey" # TODO: Parametrize
  value        = var.ai_search_create ? module.ai_search[0].resource.primary_key : data.azurerm_search_service.existing[0].primary_key
}

resource "azurerm_search_shared_private_link_service" "azure_open_ai" {
  name               = "example-spl" # TODO:
  search_service_id  = local.ai_search_id
  subresource_name   = "openai_account"
  target_resource_id = local.azure_open_ai_id
  request_message    = "please approve"
}

resource "azurerm_search_shared_private_link_service" "storage" {
  name               = "example-spl" # TODO:
  search_service_id  = local.ai_search_id
  subresource_name   = "blob"
  target_resource_id = local.storage_account_id
  request_message    = "please approve"
}

resource "azurerm_search_shared_private_link_service" "data_ingestion_function_app" {
  name               = "searchFuncAppPrivatelink" # TODO:
  search_service_id  = local.ai_search_id
  subresource_name   = "sites"
  target_resource_id = local.data_ingestion_function_app_id
  request_message    = "please approve"
}
