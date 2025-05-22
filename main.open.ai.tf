locals {
  azure_open_ai_id     = var.azure_open_ai_create ? module.azure_open_ai[0].resource_id : var.azure_open_ai.id
  azure_open_ai_parsed = provider::azurerm::parse_resource_id(local.azure_open_ai_id)

  rai_block_list_items = merge([
    for blk, blv in var.rai_block_lists : {
      for blik, bliv in blv.block_list_items : "${blk}.${blik}" => {
        block_list_key = blk
        isRegex        = bliv.isRegex
        pattern        = bliv.pattern
      }
    }
  ]...)
}

module "azure_open_ai" {
  count = var.azure_open_ai_create ? 1 : 0

  source  = "Azure/avm-res-cognitiveservices-account/azurerm"
  version = "0.7.0"

  kind                                    = "OpenAI"
  name                                    = local.resource_names.azure_open_ai_name
  location                                = var.location
  resource_group_name                     = local.resource_group_name
  sku_name                                = try(var.azure_open_ai.sku, "S0")
  public_network_access_enabled           = !var.use_private_networking
  network_acls                            = try(var.azure_open_ai.network_acls, null)
  outbound_network_access_restricted      = try(var.azure_open_ai.outbound_network_access_restricted, null)
  private_endpoints_manage_dns_zone_group = try(var.azure_open_ai.private_endpoints_manage_dns_zone_group, null)
  custom_subdomain_name                   = try(var.azure_open_ai.custom_subdomain_name, null)
  customer_managed_key                    = try(var.azure_open_ai.customer_managed_key, null)
  diagnostic_settings                     = try(var.azure_open_ai.diagnostic_settings, null)
  dynamic_throttling_enabled              = try(var.azure_open_ai.dynamic_throttling_enabled, null)
  fqdns                                   = try(var.azure_open_ai.fqdns, null)
  is_hsm_key                              = try(var.azure_open_ai.is_hsm_key, null)
  managed_identities                      = try(var.azure_open_ai.managed_identities, null)
  lock                                    = try(var.azure_open_ai.lock, null)
  rai_policies                            = try(var.azure_open_ai.rai_policies, null)
  local_auth_enabled                      = try(var.azure_open_ai.local_authentication_enabled, null)
  role_assignments                        = try(var.azure_open_ai.role_assignments, null)
  cognitive_deployments                   = try(var.azure_open_ai.deployments, null) #TODO Default
  tags                                    = merge(var.tags, try(var.azure_open_ai.tags, null))
  enable_telemetry                        = var.enable_telemetry

  private_endpoints = var.use_private_networking ? {
    primary = {
      name = local.resource_names.azure_open_ai_private_endpoint_name
      # private_dns_zone_resource_ids = var.use_private_networking ? [module.private_dns_zone_ai_search[0].resource_id] : []
      subnet_resource_id = var.ai_subnet_id
      subresource_name   = "account"
      tags               = var.tags
    }
  } : null
}

resource "azurerm_key_vault_secret" "azure_open_ai_key" {
  for_each = toset(local.resource_names.azure_open_ai_secret_names)

  key_vault_id = local.key_vault_id
  name         = each.value
  value        = var.azure_open_ai_create ? module.azure_open_ai[0].primary_key : data.azurerm_cognitive_account.existing[0].primary_key
}

resource "azapi_resource" "rai_block_list" {
  for_each = var.rai_block_lists

  type      = "Microsoft.CognitiveServices/accounts/raiBlocklists@2025-04-01-preview"
  name      = each.value.name
  parent_id = local.azure_open_ai_id
  body = {
    properties = {
      description = each.value.description
    }
  }
}

resource "azapi_resource" "rai_block_list_item" {
  for_each = local.rai_block_list_items

  type      = "Microsoft.CognitiveServices/accounts/raiBlocklists/raiBlocklistItems@2025-04-01-preview"
  name      = each.value.name
  parent_id = azapi_resource.rai_block_list[each.value.block_list_key].id
  body = {
    properties = {
      isRegex = each.value.isRegex
      pattern = each.value.pattern
    }
  }
}

resource "azapi_resource" "rai_policy" {
  for_each = var.rai_policies

  type      = "Microsoft.CognitiveServices/accounts/raiPolicies@2024-10-01"
  name      = "string"
  parent_id = local.azure_open_ai_id
  body = {
    properties = {
      basePolicyName = each.value.base_policy_name
      mode           = each.value.mode
      contentFilters = try([for item in each.value.content_filters : {
        blocking          = item.blocking
        enabled           = item.enabled
        name              = item.name
        severityThreshold = item.severity_threshold
        source            = item.source
      }], null)
      customBlocklists = try([for item in each.value.custom_block_lists : {
        source        = item.source
        blocklistName = item.block_list_name
        blocking      = item.blocking
      }], null)
    }
  }

  depends_on = [azapi_resource.rai_block_list] # ensure any block lists are created before the policy, as the custom_block_list references block lists
}
