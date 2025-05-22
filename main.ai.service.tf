locals {
  ai_service_id       = var.ai_service_create ? module.ai_service[0].resource_id : var.ai_service_id
  ai_service_parsed   = provider::azurerm::parse_resource_id(local.ai_service_id)
  ai_service_endpoint = var.ai_service_create ? module.ai_service[0].endpoint : data.azurerm_cognitive_account.existing[0].endpoint
}

module "ai_service_private_dns_zone" {
  count = var.use_private_networking && var.ai_service_private_dns_zone_create ? 1 : 0

  source  = "Azure/avm-res-network-privatednszone/azurerm"
  version = "0.3.2"

  resource_group_name = local.resource_group_name
  domain_name         = "privatelink.cognitiveservices.azure.net"

  virtual_network_links = merge({
    primary = {
      vnetlinkname = format("%s-ai-services", local.ai_virtual_network_parsed.resource_name)
      vnetid       = local.ai_virtual_network_id
    }
  }, var.ai_service_private_dns_zone.additional_virtual_network_links)

  tags             = merge(var.tags, var.ai_service_private_dns_zone.tags)
  enable_telemetry = var.enable_telemetry
}

module "ai_service" {
  count = var.ai_service_create ? 1 : 0

  source  = "Azure/avm-res-cognitiveservices-account/azurerm"
  version = "0.7.0"

  kind                                    = "AIServices"
  name                                    = local.resource_names.azure_ai_service_name
  location                                = var.location
  resource_group_name                     = local.resource_group_name
  sku_name                                = var.ai_service.sku
  public_network_access_enabled           = !var.use_private_networking
  network_acls                            = var.ai_service.network_acls
  private_endpoints_manage_dns_zone_group = var.use_private_networking
  custom_subdomain_name                   = var.ai_service.custom_subdomain_name
  customer_managed_key                    = var.ai_service.customer_managed_key
  dynamic_throttling_enabled              = var.ai_service.dynamic_throttling_enabled
  fqdns                                   = var.ai_service.fqdns
  is_hsm_key                              = var.ai_service.is_hsm_key
  managed_identities                      = var.ai_service.managed_identities
  lock                                    = var.ai_service.lock
  rai_policies                            = var.ai_service.rai_policies
  local_auth_enabled                      = var.ai_service.local_authentication_enabled
  role_assignments                        = var.ai_service.role_assignments
  tags                                    = merge(var.tags, var.ai_service.tags)
  enable_telemetry                        = var.enable_telemetry

  private_endpoints = var.use_private_networking ? {
    primary = {
      name                          = local.resource_names.azure_ai_service_private_endpoint_name
      private_dns_zone_resource_ids = var.use_private_networking ? [module.private_dns_zone_ai_search[0].resource_id] : [var.ai_service_private_dns_zone_id]
      subnet_resource_id            = var.ai_subnet_id
      subresource_name              = "searchService"
      tags                          = var.tags
    }
  } : null
}

output "ai_service_id" {
  value       = local.ai_service_parsed.resource_id
  description = "The ID of the AI Service resource."
}

output "ai_service_name" {
  value       = local.ai_service_parsed.resource_name
  description = "The name of the AI Service resource."
}

output "ai_service_endpoint" {
  value       = local.ai_service.endpoint
  description = "The endpoint of the AI Service resource."
}
