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

  name                        = local.resource_names.app_service_name
  resource_group_name         = local.resource_group_name
  location                    = var.location
  service_plan_resource_id    = local.app_service_plan_id
  kind                        = "webapp"
  os_type                     = "Linux"
  enable_application_insights = false
  virtual_network_subnet_id   = module.virtual_network[0].subnets["04_app_service"].resource_id
  tags                        = var.tags
  enable_telemetry            = var.enable_telemetry

    #   name: _appServiceName
    # applicationInsightsName: _effectiveAppInsightsName
    # applicationInsightsResourceGroupName: _effectiveAppInsightsRG
    # appServiceReuse: _azureReuseConfig.appServiceReuse
    # existingAppServiceResourceGroupName: _azureReuseConfig.existingAppServiceNameResourceGroupName
    # networkIsolation: (_networkIsolation && !_vnetReuse)
    # vnetName: (_networkIsolation && !_vnetReuse)?vnet.outputs.name:''
    # subnetId: (_networkIsolation && !_vnetReuse)?vnet.outputs.appIntSubId:''
    # appCommandLine: 'python ./app.py'
    # location: location
    # tags: union(tags, { 'azd-service-name': 'frontend' })
    # appServicePlanId: appServicePlan.outputs.id
    # runtimeName: 'python'
    # runtimeVersion: _appServiceRuntimeVersion
    # scmDoBuildDuringDeployment: true
    # basicPublishingCredentials: _networkIsolation?true:false
    # keyVaultName: keyVault.outputs.name
    # flaskSecretName: 'flaskSecretKey'

  app_settings = {
    SPEECH_SYNTHESIS_VOICE_NAME  = var.speech_synthesis_voice_name
    SPEECH_SYNTHESIS_LANGUAGE    = var.speech_synthesis_language
    SPEECH_RECOGNITION_LANGUAGE  = var.speech_recognition_language
    SPEECH_REGION                = var.location
    ORCHESTRATOR_ENDPOINT        = module.orchestrator_function_app[0].resource_uri 
    AZURE_SUBSCRIPTION_ID        = data.azurerm_client_config.current.subscription_id
    AZURE_RESOURCE_GROUP_NAME    = local.resource_group_name
    AZURE_ORCHESTRATOR_FUNC_NAME = provider::azurerm::parse_resource_id(local.orchestrator_function_app_id).resource_name
    AZURE_KEY_VAULT_ENDPOINT     = local.key_vault_endpoint
    AZURE_KEY_VAULT_NAME         = provider::azurerm::parse_resource_id(local.key_vault_id).resource_name
    STORAGE_ACCOUNT              = local.storage_account_name
    LOGLEVEL                     = "INFO"
  }

  site_config = {
    app_command_line                       = "python ./app.py"
    application_insights_key               = var.application_insights_create ? module.application_insights[0].instrumentation_key : null
    application_insights_connection_string = var.application_insights_create ? module.application_insights[0].connection_string : null
  }

  private_endpoints = var.use_private_networking ? {
    primary = {
      private_dns_zone_resource_ids = var.use_private_networking && var.virtual_network_create ? [module.private_dns_zone_web_sites[0].resource_id] : []
      subnet_resource_id            = module.virtual_network[0].subnets["04_app_service"].resource_id
      subresource_name              = "sites"
      tags                          = var.tags
    }
  } : null
}

# TODO: Permissions