module "ai_search" {
  count = var.ai_search_create ? 1 : 0

  source  = "Azure/avm-res-search-searchservice/azurerm"
  version = "0.1.5"

  name                                     = local.resource_names.ai_search_name
  location                                 = var.location
  resource_group_name                      = local.resource_group_name
  allowed_ips                              = try(var.ai_search.allowed_ips, null)
  authentication_failure_mode              = try(var.ai_search.authentication_failure_mode, null)
  customer_managed_key                     = try(var.ai_search.customer_managed_key, null)
  customer_managed_key_enforcement_enabled = try(var.ai_search.customer_managed_key_enforcement_enabled, null)
  diagnostic_settings                      = try(var.ai_search.diagnostic_settings, null)
  hosting_mode                             = try(var.ai_search.hosting_mode, null)
  local_authentication_enabled             = try(var.ai_search.local_authentication_enabled, null)
  lock                                     = try(var.ai_search.lock, null)
  managed_identities                       = try(var.ai_search.managed_identities, null)
  partition_count                          = try(var.ai_search.partition_count, 1)
  private_endpoints                        = var.use_private_networking ? try(var.ai_search.private_endpoints, null) : null
  public_network_access_enabled            = !var.use_private_networking
  replica_count                            = try(var.ai_search.replica_count, 1)
  role_assignments                         = try(var.ai_search.role_assignments, null)
  semantic_search_sku                      = lower(try(var.ai_search.sku, "standard")) != "free" ? try(var.ai_search.semantic_search_sku, null) : null
  sku                                      = try(var.ai_search.sku, "standard")
  tags                                     = merge(var.tags, try(var.ai_search.tags, null))
  enable_telemetry                         = var.enable_telemetry
}

# resource "azurerm_role_assignment" "ai_search_document_storage_access" {
#   scope                = local.document_storage_account_id
#   principal_id         = var.ai_search_create ? module.ai_search[0].identity[0].principal_id : data.azurerm_search_service.existing[0].identity[0].principal_id
#   role_definition_name = "Storage Blob Data Contributor"
# }

# resource "azurerm_role_assignment" "ai_search_open_ai_access" {
#   scope                = local.azure_open_ai_id
#   principal_id         = var.ai_search_create ? module.ai_search[0].identity[0].principal_id : data.azurerm_search_service.existing[0].identity[0].principal_id
#   role_definition_name = "Cognitive Services OpenAI User"
# }

# resource "azurerm_key_vault_secret" "ai_search_key" {
#   key_vault_id = local.key_vault_id
#   name         = "azureSearchKey" # TODO: Parametrize
#   value        = var.ai_search_create ? module.ai_search[0].resource.primary_key : data.azurerm_search_service.existing[0].primary_key
# }

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

# resource "azapi_update_resource" "document_storage_search_private_endpoint_approval" {
#   count = var.use_private_networking ? 1 : 0

#   type      = "Microsoft.Search/searchServices/sharedPrivateLinkResources@2023-11-01"
#   parent_id = local.ai_search_id
#   name      = azurerm_search_shared_private_link_service.document_storage[0].name
#   body = {
#     properties = {
#       privateLinkServiceConnectionState = {
#         status      = "Approved"
#         description = "Auto-Approved"
#       }
#     }
#   }
# }

# resource "azurerm_search_shared_private_link_service" "data_ingestion_function_app" {
# count = var.use_private_networking ? 1 : 0
#   name               = "searchFuncAppPrivatelink" # TODO:
#   search_service_id  = local.ai_search_id
#   subresource_name   = "sites"
#   target_resource_id = local.data_ingestion_function_app_id
#   request_message    = "Terraform"
# }
