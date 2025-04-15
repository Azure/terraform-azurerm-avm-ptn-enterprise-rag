module "orchestrator_function_app" {
  count = var.orchestrator_function_app_create ? 1 : 0

  source  = "Azure/avm-res-web-site/azurerm"
  version = "0.15.1"

  name                          = local.resource_names.orchestrator_function_app_name
  resource_group_name           = local.resource_group_name
  location                      = var.location
  service_plan_resource_id      = local.app_service_plan_id
  storage_account_name          = local.orchestrator_function_app_storage_account_parsed.resource_name
  kind                          = "functionapp"
  os_type                       = "Linux"
  enable_application_insights   = false
  https_only                    = true
  public_network_access_enabled = !var.use_private_networking
  virtual_network_subnet_id     = var.use_private_networking ? module.virtual_network[0].subnets["04_app_service"].resource_id : null
  tags                          = var.tags
  enable_telemetry              = var.enable_telemetry

  managed_identities = {
    system_assigned = true
  }

  app_settings = {
    APPLICATIONINSIGHTS_CONNECTION_STRING = local.application_insights_connection_string
    AzureWebJobsStorage__credential       = "managedidentity"
    AzureWebJobsStorage__accountName      = local.orchestrator_function_app_storage_account_parsed.resource_name
    AZURE_DB_ID                           = local.cosmos_db_account_id
    AZURE_DB_NAME                         = local.cosmos_db_account_parsed.resource_name
    AZURE_DB_CONVERSATIONS_CONTAINER_NAME = ""
    AZURE_DB_DATASOURCES_CONTAINER_NAME   = ""
    AZURE_KEY_VAULT_NAME                  = local.key_vault_parsed.resource_name
    AZURE_KEY_VAULT_ENDPOINT              = local.key_vault_endpoint
    FUNCTIONS_WORKER_RUNTIME              = "python"
    FUNCTIONS_EXTENSION_VERSION           = "~4"
    AZURE_SEARCH_SERVICE                  = local.ai_search_parsed.resource_name
    AZURE_SEARCH_INDEX                    = var.ai_search_index_name
    AZURE_SEARCH_APPROACH                 = var.ai_search_retrieval_approach
    AZURE_SEARCH_USE_SEMANTIC             = var.use_semantic_reranking
    AZURE_SEARCH_API_VERSION              = var.ai_search_api_version
    AZURE_OPENAI_RESOURCE                 = local.azure_open_ai_parsed.resource_name
    AZURE_OPENAI_CHATGPT_MODEL            = ""
    AZURE_OPENAI_CHATGPT_DEPLOYMENT       = ""
    AZURE_OPENAI_API_VERSION              = ""
    AZURE_OPENAI_EMBEDDING_MODEL          = ""
    AZURE_OPENAI_EMBEDDING_DEPLOYMENT     = ""
    AZURE_EMBEDDINGS_VECTOR_SIZE          = ""
    ORCHESTRATOR_MESSAGES_LANGUAGE        = var.orchestrator_message_language
    ENABLE_ORYX_BUILD                     = true
    SCM_DO_BUILD_DURING_DEPLOYMENT        = true
    LOGLEVEL                              = "INFO"
    PYTHON_ENABLE_INIT_INDEXING           = 1
    PYTHON_ISOLATE_WORKER_DEPENDENCIES    = 1
  }

  site_config = {
    always_on                              = true
    ftps_state                             = "FtpsOnly"
    minimum_tls_version                    = "1.2"
    application_insights_key               = local.application_insights_key
    application_insights_connection_string = local.application_insights_connection_string
    worker_count                           = 2
    app_scale_limit                        = 2
    elastic_instance_minimum               = 1
    cors = {
      allowed_origins = ["*"]
    }
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

resource "azurerm_role_assignment" "orchestrator_function_app_storage_access" {
  scope                = local.storage_account_id
  principal_id         = var.orchestrator_function_app_create ? module.orchestrator_function_app[0].identity[0].principal_id : data.azurerm_linux_function_app.orchestrator[0].identity[0].principal_id
  role_definition_name = "Storage Blob Data Reader"
}

resource "azurerm_role_assignment" "orchestrator_function_app_access" {
  scope                = module.orchestrator_storage_account[0].id
  principal_id         = var.orchestrator_function_app_create ? module.orchestrator_function_app[0].identity[0].principal_id : data.azurerm_linux_function_app.orchestrator[0].identity[0].principal_id
  role_definition_name = "Storage Blob Data Contributor"
}

resource "azurerm_role_assignment" "orchestrator_ai_search_access" {
  scope                = local.ai_search_id
  principal_id         = var.orchestrator_function_app_create ? module.orchestrator_function_app[0].identity[0].principal_id : data.azurerm_linux_function_app.orchestrator[0].identity[0].principal_id
  role_definition_name = "Search Index Data Reader"
}

module "data_ingestion_function_app" {
  count = var.data_ingestion_function_app_create ? 1 : 0

  source  = "Azure/avm-res-web-site/azurerm"
  version = "0.15.1"

  name                          = local.resource_names.data_ingestion_function_app_name
  resource_group_name           = local.resource_group_name
  location                      = var.location
  service_plan_resource_id      = local.app_service_plan_id
  storage_account_name          = local.data_ingestion_function_app_storage_account_parsed.resource_name
  kind                          = "functionapp"
  os_type                       = "Linux"
  enable_application_insights   = false
  https_only                    = true
  public_network_access_enabled = !var.use_private_networking
  virtual_network_subnet_id     = var.use_private_networking ? module.virtual_network[0].subnets["04_app_service"].resource_id : null
  tags                          = var.tags
  enable_telemetry              = var.enable_telemetry

  managed_identities = {
    system_assigned = true
  }

  app_settings = {
    AzureWebJobsStorage__credential   = "managedidentity"
    AzureWebJobsStorage__accountName  = local.data_ingestion_function_app_storage_account_parsed.resource_name
    DOCINT_API_VERSION                = var.document_intelligence_api_version
    AZURE_KEY_VAULT_NAME              = local.key_vault_parsed.resource_name
    AZURE_KEY_VAULT_ENDPOINT          = local.key_vault_endpoint
    FUNCTION_APP_NAME                 = local.resource_names.data_ingestion_function_app_name
    FUNCTIONS_WORKER_RUNTIME          = "python"
    FUNCTIONS_EXTENSION_VERSION       = "~4"
    SEARCH_INDEX_NAME                 = var.ai_search_index_name
    SEARCH_ANALYZER_NAME              = var.ai_search_analyzer_name
    SEARCH_API_VERSION                = var.ai_search_api_version
    SEARCH_INDEX_INTERVAL             = var.ai_search_index_interval
    STORAGE_ACCOUNT_NAME              = local.storage_account_parsed.resource_name
    STORAGE_CONTAINER                 = var.storage_account_create ? local.resource_names.storage_account_container_documents_name : null # TODO: BYO Storage & Containers
    STORAGE_CONTAINER_IMAGES          = var.storage_account_create ? local.resource_names.storage_account_container_images_name : null    # TODO: BYO Storage & Containers
    AZURE_FORMREC_SERVICE             = local.ai_services_parsed.resource_name
    AZURE_OPENAI_API_VERSION          = var.openai_api_version
    AZURE_SEARCH_APPROACH             = var.ai_search_retrieval_approach
    AZURE_SEARCH_SERVICE              = local.ai_search_parsed.resource_name
    AZURE_SEARCH_INDEX_NAME           = var.ai_search_index_name
    AZURE_OPENAI_SERVICE_NAME         = local.azure_open_ai_parsed.resource_name
    AZURE_OPENAI_EMBEDDING_DEPLOYMENT = var.embeddings_deployment_name
    AZURE_EMBEDDINGS_VECTOR_SIZE      = var.embeddings_vector_size
    AZURE_OPENAI_EMBEDDING_MODEL      = var.embeddings_model_name
    AZURE_OPENAI_CHATGPT_DEPLOYMENT   = var.chat_gpt_deployment_name
    NUM_TOKENS                        = var.chunk_num_tokens
    MIN_CHUNK_SIZE                    = var.chunk_min_size
    TOKEN_OVERLAP                     = var.chunk_token_overlap
    NETWORK_ISOLATION                 = var.use_private_networking
    AZURE_STORAGE_ACCOUNT_RG          = local.storage_account_parsed.resource_group_name
    AZURE_AOAI_RG                     = local.azure_open_ai_parsed.resource_group_name
    ENABLE_ORYX_BUILD                 = true
    SCM_DO_BUILD_DURING_DEPLOYMENT    = true
    AzureWebJobsFeatureFlags          = "EnableWorkerIndexing"
    LOGLEVEL                          = "INFO"
  }

  site_config = {
    always_on                              = true
    ftps_state                             = "FtpsOnly"
    minimum_tls_version                    = "1.2"
    application_insights_key               = local.application_insights_key
    application_insights_connection_string = local.application_insights_connection_string
    worker_count                           = 2
    app_scale_limit                        = 2
    elastic_instance_minimum               = 1
    cors = {
      allowed_origins = ["*"]
    }
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


resource "azurerm_role_assignment" "data_ingestion_ai_search_access" {
  scope                = local.ai_search_id
  principal_id         = var.data_ingestion_function_app_create ? module.data_ingestion_function_app[0].identity[0].principal_id : data.azurerm_linux_function_app.data_ingestion[0].identity[0].principal_id
  role_definition_name = "Search Index Data Contributor"
}