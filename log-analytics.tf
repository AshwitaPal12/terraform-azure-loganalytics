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

resource "azurerm_storage_management_policy" "example" {
  storage_account_id = "subscriptions/75223151-1800-43db-a8f3-b7fe605d3385/resourceGroups/gaurav/providers/Microsoft.Storage/storageAccounts/terraformteststacc01"
  // storage_account_id = azurerm_storage_account.example.id
  rule {
    name    = "rule1"
    enabled = true
    filters {
      prefix_match = ["container1/prefix1"]
      blob_types   = ["blockBlob"]
    }
    actions {
      base_blob {
        tier_to_cool_after_days_since_modification_greater_than    = 10
        tier_to_archive_after_days_since_modification_greater_than = 50
        delete_after_days_since_modification_greater_than          = 100
      }
      snapshot {
        delete_after_days_since_creation_greater_than = 30
      }
    }
  }
  rule {
    name    = "rule2"
    enabled = false
    filters {
      prefix_match = ["container2/prefix1", "container2/prefix2"]
      blob_types   = ["blockBlob"]
    }
    actions {
      base_blob {
        tier_to_cool_after_days_since_modification_greater_than    = 11
        tier_to_archive_after_days_since_modification_greater_than = 51
        delete_after_days_since_modification_greater_than          = 101
      }
      snapshot {
        change_tier_to_archive_after_days_since_creation = 90
        change_tier_to_cool_after_days_since_creation    = 23
        delete_after_days_since_creation_greater_than    = 31
      }
      version {
        change_tier_to_archive_after_days_since_creation = 9
        change_tier_to_cool_after_days_since_creation    = 90
        delete_after_days_since_creation                 = 3
      }
    }
  }
}