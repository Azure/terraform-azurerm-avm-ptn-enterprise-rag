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
  private_endpoints                       = var.use_private_networking ? var.azure_open_ai.private_endpoints : null
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
  cognitive_deployments                   = try(var.azure_open_ai.deployments, null)
  tags                                    = merge(var.tags, try(var.azure_open_ai.tags, null))
  enable_telemetry                        = var.enable_telemetry
}

