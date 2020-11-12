resource "azurerm_eventhub_namespace" "hotpath" {
  count               = length(var.hotpath_functions)
  name                = "evhn-${var.hotpath_functions[count.index].name}-${local.namespace}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"

  capacity                 = var.hotpath_functions[count.index].ehn_capacity
  auto_inflate_enabled     = true
  maximum_throughput_units = var.hotpath_functions[count.index].ehn_max_capacity
}

resource "azurerm_eventhub" "hotpath" {
  count               = length(var.hotpath_functions)
  name                = "evh-${var.hotpath_functions[count.index].name}"
  namespace_name      = azurerm_eventhub_namespace.hotpath[count.index].name
  resource_group_name = azurerm_resource_group.rg.name
  partition_count     = var.hotpath_functions[count.index].eh_partition
  message_retention   = 1
}
