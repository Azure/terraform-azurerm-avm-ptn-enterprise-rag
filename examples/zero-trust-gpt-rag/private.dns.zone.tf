module "private_dns_zone_ai_search" {
  source  = "Azure/avm-res-network-privatednszone/azurerm"
  version = "0.3.2"

  resource_group_name = azurerm_resource_group.this.name
  domain_name         = "privatelink.search.windows.net"

  virtual_network_links = {
    primary = {
      vnetlinkname = "ai-search"
      vnetid       = module.virtual_network.resource_id
    }
  }

  enable_telemetry = var.enable_telemetry
}

module "private_dns_zone_cognitive_services" {
  source  = "Azure/avm-res-network-privatednszone/azurerm"
  version = "0.3.2"

  resource_group_name = azurerm_resource_group.this.name
  domain_name         = "privatelink.cognitiveservices.azure.com"

  virtual_network_links = {
    primary = {
      vnetlinkname = "ai-cognitive-services"
      vnetid       = module.virtual_network.resource_id
    }
  }

  enable_telemetry = var.enable_telemetry
}

module "private_dns_zone_ai_services" {
  source  = "Azure/avm-res-network-privatednszone/azurerm"
  version = "0.3.2"

  resource_group_name = azurerm_resource_group.this.name
  domain_name         = "privatelink.services.ai.azure.com"

  virtual_network_links = {
    primary = {
      vnetlinkname = "ai-services"
      vnetid       = module.virtual_network.resource_id
    }
  }

  enable_telemetry = var.enable_telemetry
}

module "private_dns_zone_open_ai" {
  source  = "Azure/avm-res-network-privatednszone/azurerm"
  version = "0.3.2"

  resource_group_name = azurerm_resource_group.this.name
  domain_name         = "privatelink.openai.azure.com"

  virtual_network_links = {
    primary = {
      vnetlinkname = "open-ai"
      vnetid       = module.virtual_network.resource_id
    }
  }

  enable_telemetry = var.enable_telemetry
}

module "private_dns_zone_key_vault" {
  source  = "Azure/avm-res-network-privatednszone/azurerm"
  version = "0.3.2"

  resource_group_name = azurerm_resource_group.this.name
  domain_name         = "privatelink.vaultcore.azure.net"

  virtual_network_links = {
    primary = {
      vnetlinkname = "key-vault"
      vnetid       = module.virtual_network.resource_id
    }
  }

  enable_telemetry = var.enable_telemetry
}

module "private_dns_zone_storage" {
  source  = "Azure/avm-res-network-privatednszone/azurerm"
  version = "0.3.2"

  resource_group_name = azurerm_resource_group.this.name
  domain_name         = "privatelink.blob.core.windows.net"

  virtual_network_links = {
    primary = {
      vnetlinkname = "storage-account"
      vnetid       = module.virtual_network.resource_id
    }
  }

  enable_telemetry = var.enable_telemetry
}

module "private_dns_zone_log_analytics" {
  source  = "Azure/avm-res-network-privatednszone/azurerm"
  version = "0.3.2"

  resource_group_name = azurerm_resource_group.this.name
  domain_name         = "privatelink.monitor.azure.com"

  virtual_network_links = {
    primary = {
      vnetlinkname = "log-analytics"
      vnetid       = module.virtual_network.resource_id
    }
  }

  enable_telemetry = var.enable_telemetry
}
