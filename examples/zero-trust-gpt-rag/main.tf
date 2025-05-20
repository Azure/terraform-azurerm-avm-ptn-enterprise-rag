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
  source                = "../../"
  location              = azurerm_resource_group.this.location
  enable_telemetry      = var.enable_telemetry # see variables.tf
  resource_group_create = false
  resource_group_name   = azurerm_resource_group.this.name # keep all supporting services in the same resource group

  ai_search = {
    private_endpoints = {
      primary = {
        subnet_resource_id = module.virtual_network.subnets["01_ai"].resource_id
        private_dns_zone_resource_ids = [
          module.private_dns_zone_ai_search.resource_id,
        ]
      }
    }
  }

  ai_service = {
    custom_subdomain_name = "rhysaiservice"
    private_endpoints = {
      primary = {
        subnet_resource_id = module.virtual_network.subnets["01_ai"].resource_id
        private_dns_zone_resource_ids = [
          module.private_dns_zone_cognitive_services.resource_id,
          module.private_dns_zone_open_ai.resource_id,
          module.private_dns_zone_ai_services.resource_id
        ]
      }
    }
  }

  azure_open_ai = {
    custom_subdomain_name = "rhysopenai"
    private_endpoints = {
      primary = {
        subnet_resource_id = module.virtual_network.subnets["01_ai"].resource_id
        private_dns_zone_resource_ids = [
          module.private_dns_zone_open_ai.resource_id
        ]
      }
    }

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

  key_vault = {
    role_assignments = {
      deployment_secrets = {
        role_definition_id_or_name = "Key Vault Administrator"
        principal_id               = data.azurerm_client_config.current.object_id
      }
    }
    private_endpoints = {
      primary = {
        subnet_resource_id = module.virtual_network.subnets["01_ai"].resource_id
        private_dns_zone_resource_ids = [
          module.private_dns_zone_key_vault.resource_id
        ]
      }
    }
  }

  document_storage_account = {
    private_endpoints = {
      primary = {
        subnet_resource_id = module.virtual_network.subnets["01_ai"].resource_id
        private_dns_zone_resource_ids = [
          module.private_dns_zone_storage.resource_id
        ]
      }
    }
  }

  data_ingestion_storage_account = {
    private_endpoints = {
      primary = {
        subnet_resource_id = module.virtual_network.subnets["01_ai"].resource_id
        private_dns_zone_resource_ids = [
          module.private_dns_zone_storage.resource_id
        ]
      }
    }
  }

  orchestrator_storage_account = {
    private_endpoints = {
      primary = {
        subnet_resource_id = module.virtual_network.subnets["01_ai"].resource_id
        private_dns_zone_resource_ids = [
          module.private_dns_zone_storage.resource_id
        ]
      }
    }
  }

  application_insights_create = true
  log_analytics_workspace_create = true
  log_analytics_workspace = {
    monitor_private_link_scope = {
      primary = {
        resource_id = azurerm_resource_group.this.id
      }
    }
    monitor_private_link_scoped_service_name = "GPT-RAG"
    private_endpoints = {
      primary = {
        subnet_resource_id = module.virtual_network.subnets["01_ai"].resource_id
        private_dns_zone_resource_ids = [
          module.private_dns_zone_log_analytics.resource_id
        ]
      }
    }
  }

  app_service_plan_create = false
}

# Original Issues

# 1. Could not create multiple private endpoints
#   a) Private DNS Zone Association wasn't dynamic (hard coded key values)
# 2. Could not use managed identities
# 3. Felt very rigid rather than flexible/dynamic
