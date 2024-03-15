resource "azurerm_log_analytics_workspace" "log_analytics_wname" {
  name                          = var.workspace_name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  local_authentication_disabled = var.local_authentication_disabled
  sku                           = var.sku
  retention_in_days             = var.retention_in_days

  tags = merge(local.common_tags, tomap({
    "Name" : local.project_name_prefix
  }))
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_settings" {
  name                           = var.diagnostic_setting_name
  target_resource_id             = azurerm_log_analytics_workspace.log_analytics_wname.id
  log_analytics_workspace_id     = azurerm_log_analytics_workspace.log_analytics_wname.id
  log_analytics_destination_type = var.log_analytics_destination_type

  dynamic "enabled_log" {
    for_each = toset(var.diagnostic_setting_enabled_log_categories)

    content {
      category = enabled_log.value
    }
  }

  dynamic "metric" {
    for_each = var.diagnostic_setting_enabled_metrics

    content {
      category = metric.key
      enabled  = metric.value.enabled
    }
  }
}
