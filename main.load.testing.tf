resource "azurerm_load_test" "this" {
  count = var.load_testing_create ? 1 : 0

  name                = local.resource_names.load_testing_name
  location            = var.location
  resource_group_name = local.resource_group_name
  description         = var.load_testing_description
}