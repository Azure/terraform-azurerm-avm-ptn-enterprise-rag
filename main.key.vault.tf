module "key_vault" {
  count = var.key_vault_create ? 1 : 0

  source  = "Azure/avm-res-keyvault-vault/azurerm"
  version = "0.9.1"

  name                                    = local.resource_names.key_vault_name
  location                                = var.location
  resource_group_name                     = local.resource_group_name
  contacts                                = try(var.key_vault.contacts, {})
  diagnostic_settings                     = try(var.key_vault.diagnostic_settings, null)
  keys                                    = try(var.key_vault.keys, null)
  lock                                    = try(var.key_vault.lock, null)
  network_acls                            = try(var.key_vault.network_acls, null)
  private_endpoints                       = var.use_private_networking ? var.key_vault.private_endpoints : null
  public_network_access_enabled           = !var.use_private_networking
  private_endpoints_manage_dns_zone_group = try(var.key_vault.private_endpoints_manage_dns_zone_group, null)
  purge_protection_enabled                = try(var.key_vault.purge_protection_enabled, true)
  secrets                                 = try(var.key_vault.secrets, null)
  secrets_value                           = try(var.key_vault.secrets_value, null)
  sku_name                                = try(var.key_vault.sku, "standard")
  soft_delete_retention_days              = try(var.key_vault.soft_delete_retention_days, null)
  wait_for_rbac_before_contact_operations = try(var.key_vault.wait_for_rbac_before_contact_operations, null)
  wait_for_rbac_before_key_operations     = try(var.key_vault.wait_for_rbac_before_key_operations, null)
  wait_for_rbac_before_secret_operations  = try(var.key_vault.wait_for_rbac_before_secret_operations, null)
  tenant_id                               = data.azurerm_client_config.current.tenant_id
  role_assignments                        = try(var.key_vault.role_assignments, null)
  tags                                    = merge(var.tags, try(var.key_vault.tags, null))
  enable_telemetry                        = var.enable_telemetry
}
