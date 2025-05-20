module "app_service_plan" {
  count = var.app_service_plan_create ? 1 : 0

  source  = "Azure/avm-res-web-serverfarm/azurerm"
  version = "0.4.0"

  name                         = local.resource_names.app_service_plan_name
  resource_group_name          = local.resource_group_name
  location                     = var.location
  os_type                      = "Linux"
  app_service_environment_id   = try(var.app_service_plan.app_service_environment_id, null)
  lock                         = try(var.app_service_plan.lock, null)
  maximum_elastic_worker_count = try(var.app_service_plan.maximum_elastic_worker_count, null)
  per_site_scaling_enabled     = try(var.app_service_plan.per_site_scaling_enabled, null)
  role_assignments             = try(var.app_service_plan.role_assignments, null)
  sku_name                     = try(var.app_service_plan.sku_name, "P0v3")
  worker_count                 = try(var.app_service_plan.worker_count, 1)
  zone_balancing_enabled       = try(var.app_service_plan.zone_balancing_enabled, false)
  tags                         = merge(var.tags, try(var.app_service_plan.tags, null))
  enable_telemetry             = var.enable_telemetry
}
