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
  source                 = "../../"
  location               = azurerm_resource_group.this.location
  enable_telemetry       = var.enable_telemetry # see variables.tf
  resource_group_create  = false
  resource_group_name    = azurerm_resource_group.this.name # keep all supporting services in the same resource group
  use_private_networking = false

  ai_service = {
    custom_subdomain_name = "rhysaiservice"
  }

  azure_open_ai = {
    deployments = {
      gpt-4o-mini = {
        name = "gpt-4o-mini"
        model = {
          format  = "OpenAI"
          name    = "gpt-4o-mini"
          version = "2024-07-18"
        }
        scale = {
          type = "Standard"
        }
      }
    }
  }
}
