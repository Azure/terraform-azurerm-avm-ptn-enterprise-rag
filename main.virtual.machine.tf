module "virtual_machine" {
  count = var.use_private_networking && var.virtual_machine_create ? 1 : 0

  source  = "Azure/avm-res-compute-virtualmachine/azurerm"
  version = "0.18.0"

  resource_group_name        = local.resource_group_name
  os_type                    = "linux"
  name                       = local.resource_names.virtual_machine_name
  sku_size                   = var.virtual_machine_sku
  location                   = var.location
  zone                       = "1"
  encryption_at_host_enabled = false

  generated_secrets_key_vault_secret_config = {
    key_vault_resource_id = local.key_vault_id
  }

  managed_identities = {
    system_assigned = true
  }

  source_image_reference = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  network_interfaces = {
    private = {
      name = local.resource_names.virtual_machine_network_interface_name
      ip_configurations = {
        private = {
          name                          = "private"
          private_ip_subnet_resource_id = module.virtual_network.subnets["01_ai"].resource_id
        }
      }
    }
  }

  diagnostic_settings = local.diagnostic_settings
  tags                = var.tags

  depends_on = [module.key_vault]
}