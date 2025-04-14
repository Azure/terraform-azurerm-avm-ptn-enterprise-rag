module "orchestrator_function_app" {
  source  = "Azure/avm-res-web-site/azurerm"
  version = "0.15.1"

  name                        = local.resource_names.orchestrator_function_app_name
  resource_group_name         = local.resource_group_name
  location                    = var.location
  service_plan_resource_id    = local.app_service_plan_id
  storage_account_name        = module.orchestrator_storage_account[0].name
  kind                        = "functionapp"
  os_type                     = "Linux"
  enable_application_insights = false
  https_only = true
  virtual_network_subnet_id   = module.virtual_network[0].subnets["04_app_service"].resource_id
  tags                        = var.tags
  enable_telemetry            = var.enable_telemetry

    #   name: _orchestratorFunctionAppName
    # functionAppResourceGroupName: _orchestratorFunctionAppResourceGroupName
    # functionAppReuse: _azureReuseConfig.orchestratorFunctionAppReuse
    # location: location
    # networkIsolation: (_networkIsolation && !_vnetReuse)?true:false
    # vnetName: (_networkIsolation && !_vnetReuse)?vnet.outputs.name:''
    # subnetId: (_networkIsolation && !_vnetReuse)?vnet.outputs.appIntSubId:''
    # tags: union(tags, { 'azd-service-name': 'orchestrator' })
    # identityType: 'SystemAssigned'
    # keyVaultName: keyVault.outputs.name
    # keyVaultResourceGroupName: _keyVaultResourceGroupName
    # applicationInsightsName: _effectiveAppInsightsName
    # applicationInsightsResourceGroupName: _effectiveAppInsightsRG
    # appServicePlanId: appServicePlan.outputs.id
    # runtimeName: 'python'
    # runtimeVersion: _funcAppRuntimeVersion
    # storageAccountName: orchestratorStorage.outputs.name 
    # storageResourceGroupName: _orchestratorFunctionAppResourceGroupName // creates storage account in the same resource group as the function app
    # numberOfWorkers: 2
    # functionAppScaleLimit: 2
    # minimumElasticInstanceCount: 1
    # allowedOrigins: [ '*' ]      

  app_settings = {
    AZURE_DB_ID = local.cosmos_db_account_id
    AZURE_DB_NAME = ""
    AZURE_DB_CONVERSATIONS_CONTAINER_NAME = ""
    AZURE_DB_DATASOURCES_CONTAINER_NAME = ""
    AZURE_KEY_VAULT_NAME = provider::azurerm::parse_resource_id(local.key_vault_id).resource_name
    AZURE_SEARCH_SERVICE = provider::azurerm::parse_resource_id(local.ai_search_id).resource_name
    AZURE_SEARCH_INDEX = ""
    AZURE_SEARCH_APPROACH = ""
    AZURE_SEARCH_USE_SEMANTIC = ""
    AZURE_SEARCH_API_VERSION = ""
    AZURE_OPENAI_RESOURCE = provider::azurerm::parse_resource_id(local.azure_open_ai_id).resource_name
    AZURE_OPENAI_CHATGPT_MODEL = ""
    AZURE_OPENAI_CHATGPT_DEPLOYMENT = ""
    AZURE_OPENAI_API_VERSION = ""
    AZURE_OPENAI_EMBEDDING_MODEL = ""
    AZURE_OPENAI_EMBEDDING_DEPLOYMENT = ""
    AZURE_EMBEDDINGS_VECTOR_SIZE = ""
    ORCHESTRATOR_MESSAGES_LANGUAGE = var.orchestrator_message_language
    ENABLE_ORYX_BUILD = true 
    SCM_DO_BUILD_DURING_DEPLOYMENT = true 
    LOGLEVEL = "INFO"
    PYTHON_ENABLE_INIT_INDEXING = 1 
    PYTHON_ISOLATE_WORKER_DEPENDENCIES = 1
  }

  site_config = {
    always_on                          = true 
    ftps_state                         = "FtpsOnly"
    minimum_tls_version                  = "1.2"
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

module "data_ingestion_function_app" {
  source  = "Azure/avm-res-web-site/azurerm"
  version = "0.15.1"

  name                        = local.resource_names.data_ingestion_function_app_name
  resource_group_name         = local.resource_group_name
  location                    = var.location
  service_plan_resource_id    = local.app_service_plan_id
  storage_account_name        = module.data_ingestion_storage_account[0].name
  kind                        = "functionapp"
  os_type                     = "Linux"
  enable_application_insights = false
  https_only = true
  virtual_network_subnet_id   = module.virtual_network[0].subnets["04_app_service"].resource_id
  tags                        = var.tags
  enable_telemetry            = var.enable_telemetry

    #   name: _dataIngestionFunctionAppName
    # functionAppResourceGroupName: _dataIngestionFunctionAppResourceGroupName
    # functionAppReuse: _azureReuseConfig.dataIngestionFunctionAppReuse
    # location: location
    # networkIsolation: (_networkIsolation && !_vnetReuse)?true:false
    # vnetName: (_networkIsolation && !_vnetReuse)?vnet.outputs.name:''
    # subnetId: (_networkIsolation && !_vnetReuse)?vnet.outputs.appIntSubId:'' 
    # tags: union(tags, { 'azd-service-name': 'dataIngest' })
    # identityType: 'SystemAssigned'
    # // identityId: identityId
    # keyVaultName: keyVault.outputs.name
    # keyVaultResourceGroupName: _keyVaultResourceGroupName
    # applicationInsightsName: _effectiveAppInsightsName
    # applicationInsightsResourceGroupName: _effectiveAppInsightsRG
    # appServicePlanId: appServicePlan.outputs.id
    # runtimeName: 'python'
    # runtimeVersion: _funcAppRuntimeVersion
    # storageAccountName: dataIngestionStorage.outputs.name
    # storageResourceGroupName: _dataIngestionFunctionAppResourceGroupName // creates storage account in the same resource group as the function app
    # numberOfWorkers: 2
    # functionAppScaleLimit: 2
    # minimumElasticInstanceCount: 1
    # allowedOrigins: [ '*' ]     

  app_settings = {
    DOCINT_API_VERSION = ""
    AZURE_KEY_VAULT_NAME = provider::azurerm::parse_resource_id(local.key_vault_id).resource_name
    FUNCTION_APP_NAME = local.resource_names.data_ingestion_function_app_name
    SEARCH_INDEX_NAME = ""
    SEARCH_ANALYZER_NAME = ""
    SEARCH_API_VERSION = ""
    SEARCH_INDEX_INTERVAL = ""
    STORAGE_ACCOUNT_NAME = ""
    STORAGE_CONTAINER = ""
    STORAGE_CONTAINER_IMAGES = ""
    AZURE_FORMREC_SERVICE = "Azure AI Services Name"
    AZURE_OPENAI_API_VERSION = ""
    AZURE_SEARCH_APPROACH = ""
    AZURE_SEARCH_SERVICE = ""
    AZURE_SEARCH_INDEX_NAME = ""
    AZURE_OPENAI_SERVICE_NAME = ""
    AZURE_OPENAI_EMBEDDING_DEPLOYMENT = ""
    AZURE_EMBEDDINGS_VECTOR_SIZE = ""
    AZURE_OPENAI_EMBEDDING_MODEL = ""
    AZURE_OPENAI_CHATGPT_DEPLOYMENT = ""
    NUM_TOKENS = ""
    MIN_CHUNK_SIZE = ""
    TOKEN_OVERLAP = ""
    NETWORK_ISOLATION = var.use_private_networking
    AZURE_STORAGE_ACCOUNT_RG = ""
    AZURE_AOAI_RG = ""
    ENABLE_ORYX_BUILD = true
    SCM_DO_BUILD_DURING_DEPLOYMENT = true
    AzureWebJobsFeatureFlags = "EnableWorkerIndexing"
    LOGLEVEL = "INFO"
  }

  site_config = {
    always_on                          = true 
    ftps_state                         = "FtpsOnly"
    minimum_tls_version                  = "1.2"
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

# TODO: Identities & Permissions
