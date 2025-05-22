locals {
  # # Cosmos DB

  cosmos_db_account_id = var.cosmos_db_create ? module.cosmos_db[0].resource_id : var.cosmos_db_id
  # cosmos_db_account_parsed = provider::azurerm::parse_resource_id(local.cosmos_db_account_id)
  # cosmos_db_database_id    = var.cosmos_db_create ? module.cosmos_db[0].sql_databases["primary"].id : data.azurerm_cosmosdb_sql_database.existing[0].id
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
      name = local.resource_names.cosmos_db_private_endpoint_name
      # private_dns_zone_resource_ids = var.use_private_networking ? [module.private_dns_zone_document[0].resource_id] : []
      subnet_resource_id = var.database_subnet_id
      subresource_name   = "Sql"
      tags               = var.tags
    }
  } : null
}

resource "azurerm_key_vault_secret" "cosmos_db_key" {
  key_vault_id = local.key_vault_id
  name         = "azureDBkey"
  value        = var.cosmos_db_create ? module.cosmos_db[0].cosmos_db_primary_key.primary_key : data.azurerm_cosmosdb_account.existing[0].primary_key
}