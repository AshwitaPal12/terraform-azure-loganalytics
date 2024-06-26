variable "workspace_name" {
  description = "The name of this Log Analytics workspace."
  type        = string
  default     = ""
}

variable "resource_group_name" {
  description = "The name of the resource group to create the resources in."
  type        = string
  default     = ""
}

variable "location" {
  description = "The location to create the resources in."
  type        = string
  default     = "northeurope"
}

variable "sku" {
  description = "value"
  type        = string
  default     = "PerGB2018"
}

variable "storage_account_id" {
  description = "The ID of the Azure Storage account where diagnostic logs will be stored."
  type = string
  default = "subscriptions/75223151-1800-43db-a8f3-b7fe605d3385/resourceGroups/Ashwita/providers/Microsoft.Storage/storageAccounts/testinglogdiagnostic"
}

variable "local_authentication_disabled" {
  description = "Specifies if the Log Analytics Workspace should enforce authentication using Azure AD."
  type        = bool
  default     = true
}

variable "retention_in_days" {
  description = "The number of days that logs should be retained."
  type        = number
  default     = 90
}

variable "log_analytics_destination_type" {
  description = "The type of log analytics destination to use for this Log Analytics Workspace."
  type        = string
  default     = null
}

variable "diagnostic_setting_enabled_log_categories" {
  description = "A list of log categories to be enabled for this diagnostic setting."
  type        = list(string)
  default     = ["Audit"]
}

variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
  default     = {}
}

variable "name" {
  type        = string
  description = "A string value to describe prefix of all the resources"
  default     = ""
}

variable "default_tags" {
  type        = map(string)
  description = "A map to add common tags to all the resources"
  default = {
    "Scope" : "ACI"
    "CreatedBy" : "Terraform"
  }
}

variable "common_tags" {
  type        = map(string)
  description = "A map to add common tags to all the resources"
  default     = {}
}

variable "diagnostic_setting_name" {
  description = "The name of this azurerm monitor diagnostic setting."
  type        = string
  default     = "diagnostic-setting-name"
}

variable "diagnostic_setting_enabled_metrics" {
  description = "A map of metrics categories and their settings to be enabled for this diagnostic setting."
  type = map(object({
    enabled           = bool
    retention_days    = number
    retention_enabled = bool
  }))
  default = {
    "AllMetrics" = {
      enabled           = true
      retention_days    = 0
      retention_enabled = false
    }
  }
}