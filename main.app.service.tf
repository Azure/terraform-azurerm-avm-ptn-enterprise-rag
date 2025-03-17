module "app_service_plan" {
  count = var.app_service_plan_create ? 1 : 0

  source  = "Azure/avm-res-web-serverfarm/azurerm"
  version = "0.4.0"

  name                = local.resource_names.app_service_plan_name
  resource_group_name = local.resource_group_name
  location            = var.location
  os_type = "linux"
  sku_name = var.app_service_plan_sku_name
  worker_count = var.app_service_plan_capacity
}

module "function_app_orchestrator" {
  source  = "Azure/avm-res-web-site/azurerm"
  version = "0.15.1"

  name = local.resource_names.function_app_orchestrator_name
  resource_group_name = local.resource_group_name
  location = var.location
  service_plan_resource_id = local.app_service_plan_id
  kind = "functionapp"
  os_type = "linux"
}

module "web_app_frontend" {
  source  = "Azure/avm-res-web-site/azurerm"
  version = "0.15.1"

  name = local.resource_names.function_app_orchestrator_name
  resource_group_name = local.resource_group_name
  location = var.location
  service_plan_resource_id = local.app_service_plan_id
  kind = "webapp"
  os_type = "linux"
}
