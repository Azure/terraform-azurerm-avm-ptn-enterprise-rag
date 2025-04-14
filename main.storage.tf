module "private_dns_zone_storage" {
  count = var.use_private_networking && var.virtual_network_create ? 1 : 0

  source  = "Azure/avm-res-network-privatednszone/azurerm"
  version = "0.3.2"

  resource_group_name = local.resource_group_name
  domain_name         = "privatelink.blob.core.windows.net"

  virtual_network_links = {
    primary = {
      vnetlinkname = "storage-account"
      vnetid       = local.virtual_network_id
    }
  }

  tags             = var.tags
  enable_telemetry = var.enable_telemetry
}

module "storage_account" {
  count = var.storage_account_create ? 1 : 0

  source  = "Azure/avm-res-storage-storageaccount/azurerm"
  version = "0.5.0"

  name                = local.resource_names.storage_account_name
  resource_group_name = local.resource_group_name
  location            = var.location

  public_network_access_enabled = !var.use_private_networking

  containers = {
    documents = {
      name = local.resource_names.storage_account_container_documents_name
    }
    images = {
      name = local.resource_names.storage_account_container_images_name
    }
    nl2sql = {
      name = local.resource_names.storage_account_container_nl2sql_name
    }
  }

  private_endpoints = var.use_private_networking ? {
    primary = {
      private_dns_zone_resource_ids = var.use_private_networking && var.storage_account_create ? [module.private_dns_zone_storage[0].resource_id] : []
      subnet_resource_id            = module.virtual_network[0].subnets["01_ai"].resource_id # TODO: Dynamically fetch subnet res ID
      subresource_name              = "blob"
      tags                          = var.tags
    }
  } : null

  tags             = var.tags
  enable_telemetry = var.enable_telemetry
}

module "orchestrator_storage_account" {
  count = var.orchestrator_function_app_create ? 1 : 0

  source  = "Azure/avm-res-storage-storageaccount/azurerm"
  version = "0.5.0"

  name                          = local.resource_names.orchestrator_function_app_storage_account_name
  resource_group_name           = local.resource_group_name
  location                      = var.location
  public_network_access_enabled = !var.use_private_networking

  containers = {
    orchestrator = {
      name = "deploymentpackage"
    }
  }

  private_endpoints = var.use_private_networking ? {
    primary = {
      private_dns_zone_resource_ids = var.use_private_networking && var.virtual_network_create ? [module.private_dns_zone_storage[0].resource_id] : []
      subnet_resource_id            = module.virtual_network[0].subnets["01_ai"].resource_id
      subresource_name              = "blob"
      tags                          = var.tags
    }
  } : null

  tags             = var.tags
  enable_telemetry = var.enable_telemetry
}

module "data_ingestion_storage_account" {
  count = var.data_ingestion_function_app_create ? 1 : 0

  source  = "Azure/avm-res-storage-storageaccount/azurerm"
  version = "0.5.0"

  name                          = local.resource_names.data_ingestion_function_app_storage_account_name
  resource_group_name           = local.resource_group_name
  location                      = var.location
  public_network_access_enabled = !var.use_private_networking

  containers = {
    orchestrator = {
      name = "deploymentpackage"
    }
  }

  private_endpoints = var.use_private_networking ? {
    primary = {
      private_dns_zone_resource_ids = var.use_private_networking && var.virtual_network_create ? [module.private_dns_zone_storage[0].resource_id] : []
      subnet_resource_id            = module.virtual_network[0].subnets["01_ai"].resource_id
      subresource_name              = "blob"
      tags                          = var.tags
    }
  } : null

  tags             = var.tags
  enable_telemetry = var.enable_telemetry
}
