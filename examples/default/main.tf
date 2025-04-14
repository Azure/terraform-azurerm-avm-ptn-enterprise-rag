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
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }

  subscription_id     = ""
  storage_use_azuread = true
}

# This is the module call
module "test" {
  source                  = "../../"
  location                = "uksouth"
  enable_telemetry        = var.enable_telemetry # see variables.tf
  resource_group_create   = true
  virtual_machine_create  = false
  search_service_sku_name = "free"
}
