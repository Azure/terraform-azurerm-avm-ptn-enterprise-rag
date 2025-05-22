# Calculate resource names
locals {
  name_replacements = {
    workload       = var.resource_name_workload
    environment    = var.resource_name_environment
    location       = var.location
    location_short = coalesce(var.resource_name_location_short, substr(var.location, 0, 3))
    uniqueness     = random_string.unique_name.id
    sequence       = format("%03d", var.resource_name_sequence_start)
  }

  resource_names = { for key, value in var.resource_name_templates : key => templatestring(value, local.name_replacements) }
}

# Networking
locals {
  ai_virtual_network_id     = var.use_private_networking ? provider::azapi::parse_resource_id("Microsoft.Network/virtualNetworks/subnets", var.ai_subnet_id).parent_id : null
  ai_virtual_network_parsed = var.use_private_networking ? provider::azurerm::parse_resource_id(local.ai_virtual_network_id) : null

  my_ip_address_split = split(".", data.http.ip.response_body)
  my_cidr_slash_24    = "${join(".", slice(local.my_ip_address_split, 0, 3))}.0/24"
}
