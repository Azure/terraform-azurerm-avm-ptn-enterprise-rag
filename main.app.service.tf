module "private_dns_zone_web_sites" {
  count = var.use_private_networking && var.virtual_network_create ? 1 : 0

  source  = "Azure/avm-res-network-privatednszone/azurerm"
  version = "0.3.2"

  resource_group_name = local.resource_group_name
  domain_name         = "privatelink.azurewebsites.azure.net"

  virtual_network_links = {
    primary = {
      vnetlinkname = "aazure-websites"
      vnetid       = local.virtual_network_id
    }
  }

  enable_telemetry = var.enable_telemetry
  tags             = var.tags
}

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
  tags                = var.tags
  enable_telemetry    = var.enable_telemetry
}

# TODO: App Service Environment for Network Isolation 

module "web_app_frontend" {
  count   = var.app_service_create ? 1 : 0
  source  = "Azure/avm-res-web-site/azurerm"
  version = "0.15.1"

  name                          = local.resource_names.app_service_name
  resource_group_name           = local.resource_group_name
  location                      = var.location
  service_plan_resource_id      = local.app_service_plan_id
  kind                          = "webapp"
  os_type                       = "Linux"
  enable_application_insights   = false
  public_network_access_enabled = !var.use_private_networking
  virtual_network_subnet_id     = var.use_private_networking ? module.virtual_network[0].subnets["04_app_service"].resource_id : null
  tags                          = var.tags
  enable_telemetry              = var.enable_telemetry

  # basicPublishingCredentials: _networkIsolation?true:false
  # keyVaultName: keyVault.outputs.name
  # flaskSecretName: 'flaskSecretKey'

  app_settings = {
    APPLICATIONINSIGHTS_CONNECTION_STRING = local.application_insights_connection_string
    SPEECH_SYNTHESIS_VOICE_NAME           = var.speech_synthesis_voice_name
    SPEECH_SYNTHESIS_LANGUAGE             = var.speech_synthesis_language
    SPEECH_RECOGNITION_LANGUAGE           = var.speech_recognition_language
    SPEECH_REGION                         = var.location
    ORCHESTRATOR_ENDPOINT                 = module.orchestrator_function_app[0].resource_uri
    AZURE_SUBSCRIPTION_ID                 = data.azurerm_client_config.current.subscription_id
    AZURE_RESOURCE_GROUP_NAME             = local.resource_group_name
    AZURE_ORCHESTRATOR_FUNC_NAME          = local.orchestrator_function_app_parsed.resource_name
    AZURE_KEY_VAULT_ENDPOINT              = local.key_vault_endpoint
    AZURE_KEY_VAULT_NAME                  = local.key_vault_parsed.resource_name
    STORAGE_ACCOUNT                       = local.storage_account_parsed.resource_name
    ENABLE_ORYX_BUILD                     = true
    SCM_DO_BUILD_DURING_DEPLOYMENT        = true
    LOGLEVEL                              = "INFO"
  }

  site_config = {
    app_command_line                       = "python ./app.py"
    application_insights_key               = local.application_insights_key
    application_insights_connection_string = local.application_insights_connection_string
  }

  private_endpoints = var.use_private_networking ? {
    primary = {
      name                          = local.resource_names.app_service_private_endpoint_name
      private_dns_zone_resource_ids = var.use_private_networking && var.virtual_network_create ? [module.private_dns_zone_web_sites[0].resource_id] : []
      subnet_resource_id            = module.virtual_network[0].subnets["04_app_service"].resource_id
      subresource_name              = "sites"
      tags                          = var.tags
    }
  } : null
}

resource "azurerm_role_assignment" "app_service_access_to_storage" {
  scope                = local.storage_account_id
  principal_id         = module.web_app_frontend[0].identity[0].principal_id
  role_definition_name = "Storage Blob Data Reader"
}

resource "azurerm_role_assignment" "app_service_access_to_orchestrator_function_app" {
  scope                = local.orchestrator_function_app_id
  principal_id         = module.web_app_frontend[0].identity[0].principal_id
  role_definition_name = "Contributor"
}

resource "azurerm_role_assignment" "app_service_access_to_ai_services" {
  scope                = local.ai_services_id
  principal_id         = module.web_app_frontend[0].identity[0].principal_id
  role_definition_name = "Cognitive Services User"
}

resource "azurerm_role_assignment" "app_service_access_to_key_vault" {
  scope                = local.key_vault_id
  principal_id         = module.web_app_frontend[0].identity[0].principal_id
  role_definition_name = "Key Vault Secrets User"
}
