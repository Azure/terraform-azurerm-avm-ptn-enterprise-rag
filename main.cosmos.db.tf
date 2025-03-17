module "avm-res-documentdb-databaseaccount" {
  count = var.cosmos_db_create ? 1 : 0

  source  = "Azure/avm-res-documentdb-databaseaccount/azurerm"
  version = "0.7.0"

  name                = local.resource_names.cosmosdb_name
  resource_group_name = local.resource_group_name
  location            = var.location
}