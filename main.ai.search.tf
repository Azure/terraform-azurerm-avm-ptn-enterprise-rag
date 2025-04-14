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
  count   = var.azure_ai_search_create ? 1 : 0
  source  = "Azure/avm-res-search-searchservice/azurerm"
  version = "0.1.5"

  name                                     = local.resource_names.azure_ai_search_name
  location                                 = var.location
  resource_group_name                      = local.resource_group_name
  sku                                      = var.azure_ai_search_sku_name
  partition_count                          = 1
  replica_count                            = 1
  customer_managed_key_enforcement_enabled = var.azure_ai_search_cmk_enforcement_enabled
  hosting_mode                             = var.azure_ai_search_hosting_mode
  public_network_access_enabled            = !var.use_private_networking
  local_authentication_enabled             = var.azure_ai_search_local_auth_enabled
  semantic_search_sku                      = var.azure_ai_search_semantic_sku
  tags                                     = var.tags
  enable_telemetry                         = var.enable_telemetry

  private_endpoints = var.use_private_networking ? {
    primary = {
      private_dns_zone_resource_ids = var.use_private_networking && var.virtual_network_create ? [module.private_dns_zone_ai_search[0].resource_id] : []
      subnet_resource_id            = module.virtual_network[0].subnets["01_ai"].resource_id
      subresource_name              = "searchService"
      tags                          = var.tags
    }
  } : null
}

resource "azurerm_search_shared_private_link_service" "azure_open_ai" {
  name               = "example-spl" # TODO:
  search_service_id  = var.azure_ai_search_create ? module.ai_search[0].resource_id : var.azure_ai_search_id
  subresource_name   = "openai_account"
  target_resource_id = var.azure_open_ai_create ? module.azure_open_ai[0].resource_id : var.azure_open_ai_id
  request_message    = "please approve"
}

resource "azurerm_search_shared_private_link_service" "storage" {
  name               = "example-spl" # TODO:
  search_service_id  = var.azure_ai_search_create ? module.ai_search[0].resource_id : var.azure_ai_search_id
  subresource_name   = "blob"
  target_resource_id = var.storage_account_create ? module.storage_account[0].resource_id : var.storage_account_id
  request_message    = "please approve"
}

resource "azurerm_search_shared_private_link_service" "data_ingestion_function_app" {
  name               = "example-spl" # TODO:
  search_service_id  = var.azure_ai_search_create ? module.ai_search[0].resource_id : var.azure_ai_search_id
  subresource_name   = "sites"
  target_resource_id = var.data_ingestion_function_app_create ? module.data_ingestion_function_app[0].resource_id : var.data_ingestion_function_app_id
  request_message    = "please approve"
}

# TODO: Check if requires approvals