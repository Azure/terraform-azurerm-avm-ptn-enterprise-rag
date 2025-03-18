module "app_service_plan" {
  count = var.app_service_plan_create ? 1 : 0

  source  = "Azure/avm-res-web-serverfarm/azurerm"
  version = "0.4.0"

  name                = local.resource_names.app_service_plan_name
  resource_group_name = local.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = var.app_service_plan_sku_name
  worker_count        = var.app_service_plan_capacity
}

module "function_app_orchestrator" {
  source  = "Azure/avm-res-web-site/azurerm"
  version = "0.15.1"

  name                     = local.resource_names.orchestrator_function_app_name
  resource_group_name      = local.resource_group_name
  location                 = var.location
  service_plan_resource_id = local.app_service_plan_id
  storage_account_name     = local.storage_account_name
  kind                     = "functionapp"
  os_type                  = "Linux"
  enable_application_insights = false
}

module "web_app_frontend" {
  source  = "Azure/avm-res-web-site/azurerm"
  version = "0.15.1"

  name                     = local.resource_names.app_service_name
  resource_group_name      = local.resource_group_name
  location                 = var.location
  service_plan_resource_id = local.app_service_plan_id
  kind                     = "webapp"
  os_type                  = "Linux"
  enable_application_insights = false
}
