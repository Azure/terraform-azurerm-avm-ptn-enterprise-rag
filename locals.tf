# Calculate resource names
locals {
  name_replacements = {
    workload    = var.resource_name_workload
    environment = var.resource_name_environment
    location    = var.location
    uniqueness  = random_string.unique_name.id
    sequence    = format("%03d", var.resource_name_sequence_start)
  }

  resource_names = { for key, value in var.resource_name_templates : key => templatestring(value, local.name_replacements) }
}

# Resources
locals {
  resource_group_name = var.resource_group_create ? module.resource_group[0].name : var.resource_group_name
  virtual_network_id = var.use_private_networking && var.virtual_network_create ? module.virtual_network[0].id : var.virtual_network_id

}

locals {
  diagnostic_settings = {
    sendToLogAnalytics = {
      name                  = "sendToLogAnalytics"
      #workspace_resource_id = local.log_analytics_workspace_id
      app_service_plan_id = var.app_service_plan_create ? module.app_service_plan[0].id : var.app_service_plan_id
    }
  }
}