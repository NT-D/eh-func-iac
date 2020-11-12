resource "azurerm_application_insights" "hotpath" {
  name                = "appi-${local.namespace}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  application_type    = "web"
}

resource "azurerm_app_service_plan" "hotpath" {
  name                = "plan-${local.namespace}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "FunctionApp"

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_storage_account" "hotpath" {
  count                    = length(var.hotpath_functions)
  name                     = replace("st-${var.hotpath_functions[count.index].name}-${local.namespace}", "-", "")
  location                 = azurerm_resource_group.rg.location
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_function_app" "hotpath" {
  count                      = length(var.hotpath_functions)
  name                       = "func-${var.hotpath_functions[count.index].name}-${local.namespace}"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  app_service_plan_id        = azurerm_app_service_plan.hotpath.id
  storage_account_name       = azurerm_storage_account.hotpath[count.index].name
  storage_account_access_key = azurerm_storage_account.hotpath[count.index].primary_access_key

  version    = "~3"
  https_only = true

  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY"                                                     = azurerm_application_insights.hotpath.instrumentation_key
    "FilterEventHubNamespaceConnectionString"                                            = azurerm_eventhub_namespace.hotpath[0].default_primary_connection_string
    "FilterEventHubName"                                                                 = azurerm_eventhub.hotpath[0].name
    "LabelEventHubNamespaceConnectionString"                                             = azurerm_eventhub_namespace.hotpath[1].default_primary_connection_string
    "LabelEventHubName"                                                                  = azurerm_eventhub.hotpath[1].name
    "AzureFunctionsJobHost__extensions__eventHubs__eventProcessorOptions__maxBatchSize"  = var.hotpath_functions[count.index].maxBatchSize
    "AzureFunctionsJobHost__extensions__eventHubs__eventProcessorOptions__prefetchCount" = var.hotpath_functions[count.index].prefetchCount
  }
}
