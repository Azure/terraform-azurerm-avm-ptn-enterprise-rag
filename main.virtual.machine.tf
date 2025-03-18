module "virtual_machine" {
  count = var.use_private_networking && var.virtual_machine_create ? 1 : 0

  source  = "Azure/avm-res-compute-virtualmachine/azurerm"
  version = "0.18.0"

  resource_group_name        = local.resource_group_name
  os_type                    = "windows"
  name                       = local.resource_names.virtual_machine_name
  computer_name              = local.resource_names.virtual_machine_computer_name
  sku_size                   = var.virtual_machine_sku
  location                   = var.location
  zone                       = "1"
  encryption_at_host_enabled = false

  generated_secrets_key_vault_secret_config = {
    key_vault_resource_id = local.kay_vault_bastion_id
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
      name = local.resource_names.virtual_machine_network_interface_name
      ip_configurations = {
        private = {
          name                          = "private"
          private_ip_subnet_resource_id = module.virtual_network[0].subnets["01_ai"].resource_id
        }
      }
    }
  }

  #diagnostic_settings = local.diagnostic_settings
  tags = var.tags
}