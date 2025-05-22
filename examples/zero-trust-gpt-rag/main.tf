terraform {
  required_version = "~> 1.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.21"
    }
    modtm = {
      source  = "azure/modtm"
      version = "~> 0.3"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

provider "azurerm" {
  features {}

  storage_use_azuread = true
  subscription_id     = "283a6647-52dd-40ea-bbf6-68096a8755b8"
}

data "azurerm_client_config" "current" {}

## Section to provide a random Azure region for the resource group
# This allows us to randomize the region for the resource group.
module "regions" {
  source           = "Azure/avm-utl-regions/azurerm"
  version          = "~> 0.5.0"
  geography_filter = "United States"
}

# This allows us to randomize the region for the resource group.
resource "random_integer" "region_index" {
  max = length(module.regions.regions) - 1
  min = 0
}
## End of section to provide a random Azure region for the resource group

# This ensures we have unique CAF compliant names for our resources.
module "naming" {
  source  = "Azure/naming/azurerm"
  version = "~> 0.3"
}

# This is required for resource modules
resource "azurerm_resource_group" "this" {
  location = module.regions.regions[random_integer.region_index.result].name
  name     = module.naming.resource_group.name_unique
}

# This is the module call
module "test" {
  source                = "../../"
  location              = azurerm_resource_group.this.location
  enable_telemetry      = var.enable_telemetry # see variables.tf
  resource_group_create = false
  resource_group_name   = azurerm_resource_group.this.name # keep all supporting services in the same resource group

  ai_subnet_id           = module.virtual_network.subnets["01_ai"].resource_id
  app_services_subnet_id = module.virtual_network.subnets["03_app_service"].resource_id
  database_subnet_id     = module.virtual_network.subnets["04_database"].resource_id
}

# Original Issues

# 1. Could not create multiple private endpoints
#   a) Private DNS Zone Association wasn't dynamic (hard coded key values)
# 2. Could not use managed identities
# 3. Felt very rigid rather than flexible/dynamic
