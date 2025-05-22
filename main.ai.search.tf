locals {
  ai_search_id           = var.ai_search_create ? module.ai_search[0].resource_id : var.ai_search_id
  ai_search_parsed       = provider::azurerm::parse_resource_id(local.ai_search_id)
  ai_search_principal_id = var.ai_search_create ? module.ai_search[0].resource.identity[0].principal_id : data.azurerm_search_service.existing[0].identity[0].principal_id # Must enable identity to allow access to data sources
}

module "ai_search_private_dns_zone" {
  count = var.use_private_networking && var.ai_search_private_dns_zone_create ? 1 : 0

  source  = "Azure/avm-res-network-privatednszone/azurerm"
  version = "0.3.2"

  resource_group_name = local.resource_group_name
  domain_name         = "privatelink.search.azure.net"

  virtual_network_links = merge({
    primary = {
      vnetlinkname = format("%s-ai-search", local.ai_virtual_network_parsed.resource_name)
      vnetid       = local.ai_virtual_network_id
    }
  }, var.ai_search_private_dns_zone.additional_virtual_network_links)

  tags             = merge(var.tags, var.ai_search_private_dns_zone.tags)
  enable_telemetry = var.enable_telemetry
}

module "ai_search" {
  count = var.ai_search_create ? 1 : 0

  source  = "Azure/avm-res-search-searchservice/azurerm"
  version = "0.1.5"

  name                                     = local.resource_names.ai_search_name
  location                                 = var.location
  resource_group_name                      = local.resource_group_name
  allowed_ips                              = var.ai_search.allowed_ips
  authentication_failure_mode              = var.ai_search.authentication_failure_mode
  customer_managed_key                     = var.ai_search.customer_managed_key
  customer_managed_key_enforcement_enabled = var.ai_search.customer_managed_key_enforcement_enabled
  hosting_mode                             = var.ai_search.hosting_mode
  local_authentication_enabled             = var.ai_search.local_authentication_enabled
  lock                                     = var.ai_search.lock
  partition_count                          = var.ai_search.partition_count
  public_network_access_enabled            = !var.use_private_networking
  replica_count                            = var.ai_search.replica_count
  role_assignments                         = var.ai_search.role_assignments
  semantic_search_sku                      = lower(var.ai_search.sku) != "free" ? var.ai_search.semantic_search_sku : null
  sku                                      = var.ai_search.sku
  tags                                     = merge(var.tags, var.ai_search.tags)
  enable_telemetry                         = var.enable_telemetry

  managed_identities = {
    system_assigned = true
  }

  private_endpoints = var.use_private_networking ? {
    primary = {
      name                          = local.resource_names.ai_search_private_endpoint_name
      private_dns_zone_resource_ids = var.ai_search_private_dns_zone_create ? [module.ai_search_private_dns_zone[0].resource_id] : [var.ai_search_private_dns_zone_id]
      subnet_resource_id            = var.ai_subnet_id
      subresource_name              = "searchService"
      tags                          = var.tags
    }
  } : null
}

resource "azurerm_role_assignment" "ai_search_document_storage_access" {
  scope                = local.document_storage_account_id
  principal_id         = local.ai_search_principal_id
  role_definition_name = "Storage Blob Data Contributor"
}

resource "azurerm_role_assignment" "ai_search_open_ai_access" {
  scope                = local.azure_open_ai_id
  principal_id         = local.ai_search_principal_id
  role_definition_name = "Cognitive Services OpenAI User"
}

resource "azurerm_key_vault_secret" "ai_search_key" {
  key_vault_id = local.key_vault_id
  name         = local.resource_names.ai_search_key_name
  value        = var.ai_search_create ? module.ai_search[0].resource.primary_key : data.azurerm_search_service.existing[0].primary_key
  tags         = merge(var.tags, var.ai_search.tags)
}

resource "azurerm_search_shared_private_link_service" "azure_open_ai" {
  count = var.use_private_networking ? 1 : 0

  name               = format("pl-%s", local.azure_open_ai_parsed.resource_name)
  search_service_id  = local.ai_search_id
  subresource_name   = "openai_account"
  target_resource_id = local.azure_open_ai_id
  request_message    = "Request via Terraform"
}

# resource "azapi_update_resource" "open_ai_search_private_endpoint_approval" {
#   count = var.use_private_networking ? 1 : 0

#   type      = "Microsoft.CognitiveServices/accounts/privateEndpointConnections@2024-10-01"
#   parent_id = local.azure_open_ai_id
#   name      = azurerm_search_shared_private_link_service.azure_open_ai[0].name
#   body = {
#     properties = {
#       privateLinkServiceConnectionState = {
#         status      = "Approved"
#         description = "Auto-Approved"
#       }
#     }
#   }
# }

resource "azurerm_search_shared_private_link_service" "document_storage" {
  count = var.use_private_networking ? 1 : 0

  name               = format("pl-%s", local.document_storage_account_parsed.resource_name)
  search_service_id  = local.ai_search_id
  subresource_name   = "blob"
  target_resource_id = local.document_storage_account_id
  request_message    = "Request via Terraform"
}

resource "azurerm_search_shared_private_link_service" "data_ingestion_function_app" {
  count = var.use_private_networking ? 1 : 0

  name               = format("pl-%s", local.data_ingestion_function_app_parsed.resource_name)
  search_service_id  = local.ai_search_id
  subresource_name   = "sites"
  target_resource_id = local.data_ingestion_function_app_id
  request_message    = "Terraform"
}

output "ai_search_id" {
  value       = local.ai_search_id
  description = "The ID of the Azure AI Search resource."
}

output "ai_search_name" {
  value       = local.ai_search_parsed.resource_name
  description = "The name of the Azure AI Search resource."
}

output "ai_search_principal_id" {
  value       = local.ai_search_principal_id
  description = "The principal ID of the Azure AI Search resource."
}

output "ai_search_endpoint" {
  value       = format("https://%s.search.windows.net", local.ai_search_parsed.resource_name)
  description = "The endpoint of the Azure AI Search resource."
}

output "ai_private_dns_zone" {
  value       = var.ai_search_private_dns_zone_create ? module.ai_search_private_dns_zone[0].resource_id : null
  description = "The ID of the Private DNS Zone created for AI Search."
}
