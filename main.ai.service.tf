module "ai_service" {
  count = var.ai_service_create ? 1 : 0

  source  = "Azure/avm-res-cognitiveservices-account/azurerm"
  version = "0.7.0"

  kind                                    = "AIServices"
  name                                    = local.resource_names.azure_ai_service_name
  location                                = var.location
  resource_group_name                     = local.resource_group_name
  sku_name                                = try(var.ai_service.sku, "S0")
  public_network_access_enabled           = !var.use_private_networking
  network_acls                            = try(var.ai_service.network_acls, null)
  private_endpoints                       = var.use_private_networking ? var.ai_service.private_endpoints : null
  outbound_network_access_restricted      = try(var.ai_service.outbound_network_access_restricted, null)
  private_endpoints_manage_dns_zone_group = try(var.ai_service.private_endpoints_manage_dns_zone_group, null)
  custom_subdomain_name                   = try(var.ai_service.custom_subdomain_name, null)
  customer_managed_key                    = try(var.ai_service.customer_managed_key, null)
  diagnostic_settings                     = try(var.ai_service.diagnostic_settings, null)
  dynamic_throttling_enabled              = try(var.ai_service.dynamic_throttling_enabled, null)
  fqdns                                   = try(var.ai_service.fqdns, null)
  is_hsm_key                              = try(var.ai_service.is_hsm_key, null)
  managed_identities                      = try(var.ai_service.managed_identities, null)
  lock                                    = try(var.ai_service.lock, null)
  rai_policies                            = try(var.ai_service.rai_policies, null)
  local_auth_enabled                      = try(var.ai_service.local_authentication_enabled, null)
  role_assignments                        = try(var.ai_service.role_assignments, null)
  tags                                    = merge(var.tags, try(var.ai_service.tags, null))
  enable_telemetry                        = var.enable_telemetry
}
