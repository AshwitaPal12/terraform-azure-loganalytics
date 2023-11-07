provider "azurerm" {
  features {}
}

locals {
  env         = var.env
  name        = var.pname
  name_prefix = "${local.env}${local.name}"
}

resource "azurerm_resource_group" "rg" {
  name     = "${local.name_prefix}-rg"
  location = var.location
}

module "log_analytics" {
  # source = "git::https://github.com/tothenew/terraform-azure-loganalytics.git"
  source = "../.."

  workspace_name          = "${local.name_prefix}-log"
  resource_group_name     = azurerm_resource_group.rg.name
  location                = azurerm_resource_group.rg.location
  diagnostic_setting_name = "${local.name_prefix}-log-diagnostic-setting"

  diagnostic_setting_enabled_metrics = {
    "AllMetrics" = {
      enabled           = true
      retention_days    = 30
      retention_enabled = true
    }
  }
}

data "azurerm_subscription" "subscription" {}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_settings" {
  name                       = "${local.name_prefix}-activity-logs"
  target_resource_id         = data.azurerm_subscription.subscription.id
  log_analytics_workspace_id = module.log_analytics.workspace_id

  enabled_log {
    category = "Administrative"
  }

  enabled_log {
    category = "Alert"
  }

  enabled_log {
    category = "Policy"
  }

  enabled_log {
    category = "Security"
  }
}