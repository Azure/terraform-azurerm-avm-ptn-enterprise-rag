resource "random_string" "unique_name" {
  length  = 3
  special = false
  upper   = false
  numeric = false
}

module "resource_group" {
  count = var.resource_group_create ? 1 : 0

  source  = "Azure/avm-res-resources-resourcegroup/azurerm"
  version = "0.2.1"

  name     = local.resource_names.resource_group_name
  location = var.location

  tags = var.tags
}
