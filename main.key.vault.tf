locals {
  key_vault_id       = var.key_vault_create ? module.key_vault[0].resource_id : var.key_vault_id
  key_vault_parsed   = provider::azurerm::parse_resource_id(local.key_vault_id)
  key_vault_endpoint = var.key_vault_create ? module.key_vault[0].vault_uri : data.azurerm_key_vault.key_vault.vault_uri

  bastion_key_vault_id     = var.bastion_key_vault_create ? module.bastion_key_vault[0].resource_id : var.bastion_key_vault_id
  bastion_key_vault_parsed = provider::azurerm::parse_resource_id(local.bastion_key_vault_id)
}

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

  private_endpoints = var.use_private_networking ? {
    primary = {
      name = local.resource_names.key_vault_private_endpoint_name
      # private_dns_zone_resource_ids = var.use_private_networking ? [module.private_dns_zone_ai_search[0].resource_id] : []
      subnet_resource_id = var.ai_subnet_id
      subresource_name   = "searchService"
      tags               = var.tags
    }
  } : null
}

module "bastion_key_vault" {
  count = var.bastion_key_vault_create ? 1 : 0

  source  = "Azure/avm-res-keyvault-vault/azurerm"
  version = "0.9.1"

  name                = local.resource_names.bastion_key_vault_name
  location            = var.location
  resource_group_name = local.resource_group_name
  contacts            = try(var.bastion_key_vault.contacts, {})
  diagnostic_settings = try(var.bastion_key_vault.diagnostic_settings, null)
  keys                = try(var.bastion_key_vault.keys, null)
  lock                = try(var.bastion_key_vault.lock, null)
  network_acls = {
    bypass = "AzureServices"
  }
  public_network_access_enabled           = !var.use_private_networking
  purge_protection_enabled                = try(var.bastion_key_vault.purge_protection_enabled, true)
  secrets                                 = try(var.bastion_key_vault.secrets, null)
  secrets_value                           = try(var.bastion_key_vault.secrets_value, null)
  sku_name                                = try(var.bastion_key_vault.sku, "standard")
  soft_delete_retention_days              = try(var.bastion_key_vault.soft_delete_retention_days, null)
  wait_for_rbac_before_contact_operations = try(var.bastion_key_vault.wait_for_rbac_before_contact_operations, null)
  wait_for_rbac_before_key_operations     = try(var.bastion_key_vault.wait_for_rbac_before_key_operations, null)
  wait_for_rbac_before_secret_operations  = try(var.bastion_key_vault.wait_for_rbac_before_secret_operations, null)
  tenant_id                               = data.azurerm_client_config.current.tenant_id
  role_assignments                        = try(var.bastion_key_vault.role_assignments, null)
  tags                                    = merge(var.tags, try(var.bastion_key_vault.tags, null))
  enable_telemetry                        = var.enable_telemetry
}
