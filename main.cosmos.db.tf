module "cosmos_db" {
  count = var.cosmos_db_create ? 1 : 0

  source  = "Azure/avm-res-documentdb-databaseaccount/azurerm"
  version = "0.7.0"

  name                = local.resource_names.cosmosdb_name
  resource_group_name = local.resource_group_name
  location            = var.location

  consistency_policy = {
    consistency_level = "Session"
  }

  geo_locations = {
    primary = {
      location          = var.location
      failover_priority = 0
      zone_redundant = var.cosmos_db_zone_redundant
    }
  }

  automatic_failover_enabled = var.cosmos_db_automatic_failover_enabled

  sql_databases = {
    autoscale_settings = {
      max_throughput = var.cosmos_db_max_throughput
    }
    containers = {
      conversations = {
        name = local.resource_names.cosmosdb_container_conversations_name
        partition_key_paths = ["/id"]
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
      models = {
        name = local.resource_names.cosmosdb_container_models_name
        partition_key_paths = ["/id"]
        analytical_storage_ttl = var.cosmos_db_analytical_storage_ttl
        indexing_policy = {
          indexing_mode = "none"
        }
        default_ttl = var.cosmos_db_default_ttl
      }
    }
  }
}
