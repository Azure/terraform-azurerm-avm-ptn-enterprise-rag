module "data_science_vm" {
  count = var.data_science_vm_create && var.use_private_networking ? 1 : 0

  source  = "Azure/avm-res-compute-virtualmachine/azurerm"
  version = "0.18.0"

  resource_group_name        = local.resource_group_name
  os_type                    = "windows"
  name                       = local.resource_names.dsvm_name
  computer_name              = local.resource_names.dsvm_computer_name
  sku_size                   = try(var.data_science_vm.sku, "Standard_D4s_v3")
  location                   = var.location
  zone                       = try(var.data_science_vm.zone, null)
  encryption_at_host_enabled = try(var.data_science_vm.encryption_at_host_enabled, false)

  generated_secrets_key_vault_secret_config = {
    key_vault_resource_id = local.bastion_key_vault_id
  }

  managed_identities = {
    system_assigned = true
  }

  source_image_reference = {
    publisher = "microsoft-dsvm"
    offer     = "dsvm-win-2019"
    sku       = "winserver-2019"
    version   = "latest"
  }

  network_interfaces = {
    private = {
      name = local.resource_names.dsvm_network_interface_name
      ip_configurations = {
        private = {
          name                          = "private"
          private_ip_subnet_resource_id = var.ai_subnet_id
        }
      }
    }
  }

  #diagnostic_settings = local.diagnostic_settings
  tags             = var.tags
  enable_telemetry = var.enable_telemetry
}

# The VM's Managed Identity is granted access to create AI Search indexes and indexers for convenience, as the role is also assigned to the provisioning identity afterward.
resource "azurerm_role_assignment" "dvsm" {
  count = var.data_science_vm_create && var.use_private_networking ? 1 : 0

  scope                = local.ai_search_id
  principal_id         = module.virtual_machine[0].identity[0].principal_id
  role_definition_name = "Search Service Contributor"
}