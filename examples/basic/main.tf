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
}