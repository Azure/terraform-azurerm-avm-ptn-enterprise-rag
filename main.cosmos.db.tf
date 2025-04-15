module "private_dns_zone_document" {
  count = var.use_private_networking && var.virtual_network_create ? 1 : 0

  source  = "Azure/avm-res-network-privatednszone/azurerm"
  version = "0.3.2"

  resource_group_name = local.resource_group_name
  domain_name         = "privatelink.documents.azure.net"

  virtual_network_links = {
    primary = {
      vnetlinkname = "document-db"
      vnetid       = local.virtual_network_id
    }
  }

  tags             = var.tags
  enable_telemetry = var.enable_telemetry
}

module "cosmos_db" {
  count = var.cosmos_db_create ? 1 : 0

  source  = "Azure/avm-res-documentdb-databaseaccount/azurerm"
  version = "0.7.0"

  name                          = local.resource_names.cosmos_db_name
  resource_group_name           = local.resource_group_name
  location                      = var.location
  public_network_access_enabled = !var.use_private_networking
  tags                          = var.tags
  enable_telemetry              = var.enable_telemetry

  consistency_policy = {
    consistency_level = "Session"
  }

  geo_locations = [{
    location          = var.location
    failover_priority = 0
    zone_redundant    = var.cosmos_db_zone_redundant
  }]

  automatic_failover_enabled = var.cosmos_db_automatic_failover_enabled

  sql_databases = {
    primary = {
      name = local.resource_names.cosmos_db_database_name
      autoscale_settings = {
        max_throughput = var.cosmos_db_max_throughput
      }
      containers = {
        conversations = {
          name                   = local.resource_names.cosmos_db_container_conversations_name
          partition_key_paths    = ["/id"]
          analytical_storage_ttl = var.cosmos_db_analytical_storage_ttl
          indexing_policy = {
            indexing_mode = "consistent"
            included_paths = [
              {
                path = "/*"
              }
            ]
          }
          default_ttl = var.cosmos_db_default_ttl
        }
        data_sources = {
          name                   = local.resource_names.cosmos_db_container_datasources_name
          partition_key_paths    = ["/id"]
          analytical_storage_ttl = var.cosmos_db_analytical_storage_ttl
          indexing_policy = {
            indexing_mode = "none"
          }
          default_ttl = var.cosmos_db_default_ttl
        }
      }
    }
  }

  private_endpoints = var.use_private_networking ? {
    primary = {
      name                          = local.resource_names.cosmos_db_private_endpoint_name
      private_dns_zone_resource_ids = var.use_private_networking && var.virtual_network_create ? [module.private_dns_zone_document[0].resource_id] : []
      subnet_resource_id            = module.virtual_network[0].subnets["05_database"].resource_id
      subresource_name              = "Sql"
      tags                          = var.tags
    }
  } : null
}

resource "azurerm_key_vault_secret" "cosmos_db_key" {
  key_vault_id = local.key_vault_id
  name         = "azureDBkey"
  value        = var.cosmos_db_create ? module.cosmos_db[0].cosmos_db_primary_key.primary_key : data.azurerm_cosmosdb_account.existing[0].primary_key
}