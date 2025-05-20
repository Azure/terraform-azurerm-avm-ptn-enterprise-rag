module "document_storage_account" {
  count = var.document_storage_account_create ? 1 : 0

  source  = "Azure/avm-res-storage-storageaccount/azurerm"
  version = "0.5.0"

  name                                    = local.resource_names.document_storage_account_name
  resource_group_name                     = local.resource_group_name
  location                                = var.location
  access_tier                             = try(var.document_storage_account.access_tier, "Hot")
  account_kind                            = try(var.document_storage_account.account_kind, "StorageV2")
  account_replication_type                = try(var.document_storage_account.account_replication_type, "LRS")
  account_tier                            = try(var.document_storage_account.account_tier, "Standard")
  allow_nested_items_to_be_public         = try(var.document_storage_account.allow_nested_items_to_be_public, false)
  allowed_copy_scope                      = try(var.document_storage_account.allowed_copy_scope, null)
  cross_tenant_replication_enabled        = try(var.document_storage_account.cross_tenant_replication_enabled, true)
  custom_domain                           = try(var.document_storage_account.custom_domain, null)
  https_traffic_only_enabled              = try(var.document_storage_account.https_traffic_only_enabled, true)
  shared_access_key_enabled               = try(var.document_storage_account.shared_access_key_enabled, false)
  infrastructure_encryption_enabled       = try(var.document_storage_account.infrastructure_encryption_enabled, false)
  min_tls_version                         = try(var.document_storage_account.min_tls_version, "TLS1_2")
  default_to_oauth_authentication         = try(var.document_storage_account.default_to_oauth_authentication, false)
  diagnostic_settings_storage_account     = try(var.document_storage_account.diagnostic_settings, null)
  diagnostic_settings_blob                = try(var.document_storage_account.diagnostic_settings_blob, null)
  diagnostic_settings_file                = try(var.document_storage_account.diagnostic_settings_file, null)
  network_rules                           = try(var.document_storage_account.network_rules, null)
  routing                                 = try(var.document_storage_account.routing, null)
  public_network_access_enabled           = !var.use_private_networking
  private_endpoints_manage_dns_zone_group = try(var.document_storage_account.private_endpoints_manage_dns_zone_group, null)
  private_endpoints                       = var.use_private_networking ? { for key, value in var.document_storage_account.private_endpoints : key => merge(value, { subresource_name = "blob" }) } : null
  role_assignments                        = try(var.document_storage_account.role_assignments, null)

  containers = {
    documents = {
      name = "document"
    }
    images = {
      name = "document-images"
    }
    nl2sql = {
      name = "nl2sql"
    }
  } # TODO: Does this need customizing?

  tags             = merge(var.tags, try(var.document_storage_account.tags, {}))
  enable_telemetry = var.enable_telemetry
}

module "orchestrator_storage_account" {
  count = var.orchestrator_storage_account_create ? 1 : 0

  source  = "Azure/avm-res-storage-storageaccount/azurerm"
  version = "0.5.0"

  name                                    = local.resource_names.orchestrator_storage_account_name
  resource_group_name                     = local.resource_group_name
  location                                = var.location
  access_tier                             = try(var.orchestrator_storage_account.access_tier, "Hot")
  account_kind                            = try(var.orchestrator_storage_account.account_kind, "StorageV2")
  account_replication_type                = try(var.orchestrator_storage_account.account_replication_type, "LRS")
  account_tier                            = try(var.orchestrator_storage_account.account_tier, "Standard")
  allow_nested_items_to_be_public         = try(var.orchestrator_storage_account.allow_nested_items_to_be_public, false)
  allowed_copy_scope                      = try(var.orchestrator_storage_account.allowed_copy_scope, null)
  cross_tenant_replication_enabled        = try(var.orchestrator_storage_account.cross_tenant_replication_enabled, true)
  custom_domain                           = try(var.orchestrator_storage_account.custom_domain, null)
  https_traffic_only_enabled              = try(var.orchestrator_storage_account.https_traffic_only_enabled, true)
  shared_access_key_enabled               = false
  infrastructure_encryption_enabled       = try(var.orchestrator_storage_account.infrastructure_encryption_enabled, false)
  min_tls_version                         = try(var.orchestrator_storage_account.min_tls_version, "TLS1_2")
  default_to_oauth_authentication         = try(var.orchestrator_storage_account.default_to_oauth_authentication, false)
  diagnostic_settings_storage_account     = try(var.orchestrator_storage_account.diagnostic_settings, null)
  diagnostic_settings_blob                = try(var.orchestrator_storage_account.diagnostic_settings_blob, null)
  diagnostic_settings_file                = try(var.orchestrator_storage_account.diagnostic_settings_file, null)
  network_rules                           = try(var.orchestrator_storage_account.network_rules, null)
  routing                                 = try(var.orchestrator_storage_account.routing, null)
  public_network_access_enabled           = !var.use_private_networking
  private_endpoints_manage_dns_zone_group = try(var.orchestrator_storage_account.private_endpoints_manage_dns_zone_group, null)
  private_endpoints                       = var.use_private_networking ? { for key, value in var.orchestrator_storage_account.private_endpoints : key => merge(value, { subresource_name = "blob" }) } : null
  role_assignments                        = try(var.orchestrator_storage_account.role_assignments, null)

  containers = {
    deploymentpackage = {
      name = "deploymentpackage"
    }
  }

  tags             = merge(var.tags, try(var.orchestrator_storage_account.tags, {}))
  enable_telemetry = var.enable_telemetry
}

module "data_ingestion_storage_account" {
  count = var.data_ingestion_storage_account_create ? 1 : 0

  source  = "Azure/avm-res-storage-storageaccount/azurerm"
  version = "0.5.0"

  name                                    = local.resource_names.data_ingestion_storage_account_name
  resource_group_name                     = local.resource_group_name
  location                                = var.location
  access_tier                             = try(var.data_ingestion_storage_account.access_tier, "Hot")
  account_kind                            = try(var.data_ingestion_storage_account.account_kind, "StorageV2")
  account_replication_type                = try(var.data_ingestion_storage_account.account_replication_type, "LRS")
  account_tier                            = try(var.data_ingestion_storage_account.account_tier, "Standard")
  allow_nested_items_to_be_public         = try(var.data_ingestion_storage_account.allow_nested_items_to_be_public, false)
  allowed_copy_scope                      = try(var.data_ingestion_storage_account.allowed_copy_scope, null)
  cross_tenant_replication_enabled        = try(var.data_ingestion_storage_account.cross_tenant_replication_enabled, true)
  custom_domain                           = try(var.data_ingestion_storage_account.custom_domain, null)
  https_traffic_only_enabled              = try(var.data_ingestion_storage_account.https_traffic_only_enabled, true)
  shared_access_key_enabled               = false
  infrastructure_encryption_enabled       = try(var.data_ingestion_storage_account.infrastructure_encryption_enabled, false)
  min_tls_version                         = try(var.data_ingestion_storage_account.min_tls_version, "TLS1_2")
  default_to_oauth_authentication         = try(var.data_ingestion_storage_account.default_to_oauth_authentication, false)
  diagnostic_settings_storage_account     = try(var.data_ingestion_storage_account.diagnostic_settings, null)
  diagnostic_settings_blob                = try(var.data_ingestion_storage_account.diagnostic_settings_blob, null)
  diagnostic_settings_file                = try(var.data_ingestion_storage_account.diagnostic_settings_file, null)
  network_rules                           = try(var.data_ingestion_storage_account.network_rules, null)
  routing                                 = try(var.data_ingestion_storage_account.routing, null)
  public_network_access_enabled           = !var.use_private_networking
  private_endpoints_manage_dns_zone_group = try(var.data_ingestion_storage_account.private_endpoints_manage_dns_zone_group, null)
  private_endpoints                       = var.use_private_networking ? { for key, value in var.data_ingestion_storage_account.private_endpoints : key => merge(value, { subresource_name = "blob" }) } : null
  role_assignments                        = try(var.data_ingestion_storage_account.role_assignments, null)

  containers = {
    deploymentpackage = {
      name = "deploymentpackage"
    }
  }

  tags             = merge(var.tags, try(var.data_ingestion_storage_account.tags, {}))
  enable_telemetry = var.enable_telemetry
}
