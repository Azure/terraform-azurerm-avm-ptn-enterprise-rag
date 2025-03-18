module "private_dns_zone_key_vault" {
  count = var.use_private_networking && var.key_vault_create ? 1 : 0

  source  = "Azure/avm-res-network-privatednszone/azurerm"
  version = "0.3.2"

  resource_group_name = local.resource_group_name
  domain_name         = "privatelink.vaultcore.azure.net"

  virtual_network_links = {
    primary = {
      vnetlinkname = "key-vault"
      vnetid       = local.virtual_network_id
    }
  }

  tags = var.tags
}

module "key_vault" {
  count = var.key_vault_create ? 1 : 0

  source  = "Azure/avm-res-keyvault-vault/azurerm"
  version = "0.9.1"

  name                          = local.resource_names.key_vault_name
  location                      = var.location
  resource_group_name           = local.resource_group_name
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  public_network_access_enabled = !var.use_private_networking

  private_endpoints = var.use_private_networking ? {
    primary = {
      private_dns_zone_resource_ids = [module.private_dns_zone_key_vault[0].resource_id]
      subnet_resource_id            = module.virtual_network[0].subnets["01_ai"].resource_id
      subresource_name              = ["vault"]
      tags                          = var.tags
    }
  } : null

  role_assignments = {
    deployment_user_secrets = {
      role_definition_id_or_name = "Key Vault Administrator"
      principal_id               = data.azurerm_client_config.current.object_id
    }
  }

  #diagnostic_settings = local.diagnostic_settings
  tags = var.tags

  enable_telemetry = var.enable_telemetry
}

module "key_vault_bastion" {
  count = var.use_private_networking && var.key_vault_bastion_create ? 1 : 0

  source  = "Azure/avm-res-keyvault-vault/azurerm"
  version = "0.9.1"

  name                          = local.resource_names.key_vault_bastion_name
  location                      = var.location
  resource_group_name           = local.resource_group_name
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  public_network_access_enabled = true

  role_assignments = {
    deployment_user_secrets = {
      role_definition_id_or_name = "Key Vault Administrator"
      principal_id               = data.azurerm_client_config.current.object_id
    }
  }

  network_acls = var.use_private_networking ? null : {
    bypass   = "AzureServices"
    ip_rules = [local.my_cidr_slash_24]
  }

  #diagnostic_settings = local.diagnostic_settings
  tags = var.tags

  enable_telemetry = var.enable_telemetry
}