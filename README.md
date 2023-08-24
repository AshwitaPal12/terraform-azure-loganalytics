# azurerm-log-analytics

[![Lint Status](https://github.com/tothenew/terraform-aws-template/workflows/Lint/badge.svg)](https://github.com/tothenew/terraform-aws-template/actions)
[![LICENSE](https://img.shields.io/github/license/tothenew/terraform-aws-template)](https://github.com/tothenew/terraform-aws-template/blob/master/LICENSE)

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [azurerm](#requirement\_terraform) | >= 3.39.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_log_analytics_workspace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource |
| [azurerm_monitor_diagnostic_setting](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |

## Azure Log Analytics Workspace and Diagnostic Settings Terraform Module

This Terraform module creates an Azure Log Analytics Workspace along with diagnostic settings for monitoring. The module offers the following features and resources:

### Features:

- **Azure Log Analytics Workspace:** Deploys an Azure Log Analytics Workspace, allowing you to collect and analyze data from various sources.

- **Diagnostic Settings:** Sets up diagnostic settings for the Log Analytics Workspace, enabling comprehensive monitoring and alerting.

### Resources Created:

- **Azure Log Analytics Workspace (`azurerm_log_analytics_workspace`):** 
  - Name: `var.workspace_name`
  - Resource Group: `var.resource_group_name`
  - Location: `var.location`
  - SKU: `var.sku`
  - Retention in Days: `var.retention_in_days`
  - Local Authentication Disabled: `var.local_authentication_disabled`
  - Tags: Common tags merged with `"Name": local.project_name_prefix`

- **Diagnostic Settings (`azurerm_monitor_diagnostic_setting`):** 
  - Name: `var.diagnostic_setting_name`
  - Target Resource: `azurerm_log_analytics_workspace.log_analytics_wname`
  - Log Analytics Workspace ID: `azurerm_log_analytics_workspace.log_analytics_wname.id`
  - Log Analytics Destination Type: `var.log_analytics_destination_type`
  - Enabled Log Categories: `var.diagnostic_setting_enabled_log_categories`
  - Enabled Metric Categories: Configurable through `var.diagnostic_setting_enabled_metrics`
    - Metrics include retention policy settings.

## Prerequisites

Before using this Terraform module, ensure that you have the following prerequisites:

1. **Azure Account**: You need an active Azure account to deploy the resources.
2. **Terraform**: Install Terraform on your local machine. You can download it from the [official Terraform website](https://www.terraform.io/downloads.html).
3. **Azure CLI**: Install the Azure CLI on your local machine. You can download it from the [Azure CLI website](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli).

- Terraform version >= 1.3.0 is required.
- Azure provider version >= 3.16.0 is required.

## Configure Azure Provider

To configure the Azure provider, you need to set up the necessary Azure credentials. If you already have the Azure CLI installed and authenticated with Azure, Terraform will use the same credentials.

If you haven't authenticated with Azure, you can do so by running:

```bash
az login
```


## Clone the Repository

First, clone this repository to your local machine using the following command:

```bash
git clone <repository_url>
cd <repository_name>
```

## Initialize Terraform

Once you have cloned the repository, navigate to the module directory and initialize Terraform:

```bash
cd path/to/module_directory
terraform init
```

This will download the necessary plugins required for Terraform to work with Azure.

## Apply the Terraform Configuration

After configuring the input variables, you can apply the Terraform configuration to create the Azure Container Group:

```bash
terraform apply
```

Terraform will show you the changes that will be applied to the infrastructure. Type `yes` to confirm and apply the changes.

## Clean Up

To clean up the resources created by Terraform, you can use the `destroy` command:

```bash
terraform destroy
```

Terraform will show you the resources that will be destroyed. Type `yes` to confirm and destroy the resources.


```
# Terraform Module: Azure Log Analytics Workspace

This Terraform module creates an Azure Log Analytics Workspace with diagnostic settings.

## Usage

```hcl
module "log_analytics" {
  source                     = "path/to/module"
  workspace_name             = "my-log-analytics-workspace"
  resource_group_name        = "my-resource-group"
  location                   = "East US"
  sku                        = "PerGB2018"
  local_authentication_disabled = true
  retention_in_days          = 90
  diagnostic_setting_name    = "my-diagnostic-setting"
  diagnostic_setting_enabled_log_categories = ["Audit"]
  diagnostic_setting_enabled_metrics = {
    "AllMetrics" = {
      enabled = true
      retention_days = 0
      retention_enabled = false
    }
  }
}

```

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| workspace_name | The name of the Log Analytics workspace. | `string` | |
| resource_group_name | The name of the resource group to create the resources in. | `string` | |
| location | The location to create the resources in. | `string` | |
| sku | The SKU of the Log Analytics workspace. | `string` | `PerGB2018` |
| local_authentication_disabled | Specifies if the Log Analytics Workspace should enforce authentication using Azure AD. | `bool` | `true` |
| retention_in_days | The number of days that logs should be retained. | `number` | `90` |
| diagnostic_setting_name | The name of the diagnostic setting. | `string` | `diagnostic-setting-name` |
| diagnostic_setting_enabled_log_categories | A list of log categories to be enabled for this diagnostic setting. | `list(string)` | `["Audit"]` |
| diagnostic_setting_enabled_metrics | A map of metrics categories and their settings to be enabled for this diagnostic setting. | `map(object({ enabled = bool, retention_days = number, retention_enabled = bool }))` | See example in `variables.tf` |

## Outputs

| Name | Description |
|------|-------------|
| workspace_id | The ID of the Log Analytics workspace. |
| workspace_customer_id | The workspace (customer) ID of the Log Analytics workspace. |
| primary_shared_key | The primary shared key of the Log Analytics workspace. |
| secondary_shared_key | The secondary shared key of the Log Analytics workspace. |

## List of variables

| Variable Name                                 | Description                                                        | Type            | Required | Default Value       |
|-----------------------------------------------|--------------------------------------------------------------------|-----------------|----------|---------------------|
| `workspace_name`                              | The name of this Log Analytics workspace.                         | `string`        | Yes      |                     |
| `resource_group_name`                         | The name of the resource group to create the resources in.        | `string`        | Yes      |                     |
| `location`                                    | The location to create the resources in.                          | `string`        | Yes      |                     |
| `sku`                                         | The SKU for the Log Analytics workspace.                          | `string`        | No       | `"PerGB2018"`       |
| `local_authentication_disabled`                | Specifies if the Log Analytics Workspace should enforce authentication using Azure AD. | `bool` | No | `true` |
| `retention_in_days`                           | The number of days that logs should be retained.                  | `number`        | No       | `90`                |
| `log_analytics_destination_type`              | The type of log analytics destination to use for this Log Analytics Workspace. | `string` | No | `null`            |
| `diagnostic_setting_enabled_log_categories`   | A list of log categories to be enabled for this diagnostic setting. | `list(string)` | No    | `["Audit"]`       |
| `tags`                                        | A map of tags to assign to the resources.                         | `map(string)`   | No       |                     |
| `name`                                        | A string value to describe prefix of all the resources.            | `string`        | No       | `""`                |
| `default_tags`                                | A map to add common tags to all the resources.                    | `map(string)`   | No       | See below           |
| `common_tags`                                 | A map to add common tags to all the resources.                    | `map(string)`   | No       | `{}`                |
| `diagnostic_setting_name`                     | The name of this azurerm monitor diagnostic setting.              | `string`        | No       | `"diagnostic-setting-name"` |
| `diagnostic_setting_enabled_metrics`           | A map of metrics categories and their settings to be enabled for this diagnostic setting. | `map(object)` | No | See below |

Default value for `default_tags`:
```hcl
{
  "Scope": "ACI",
  "CreatedBy": "Terraform"
}
```

Default value for `diagnostic_setting_enabled_metrics`:
```hcl
{
  "AllMetrics" = {
    enabled = true
    retention_days = 0
    retention_enabled = false
  }
}
```

Please note that the variables in the "Required" column that are marked "No" can be left empty if you don't want to provide a value for them.

## Authors

Module managed by [TO THE NEW Pvt. Ltd.](https://github.com/tothenew)

## License

Apache 2 Licensed. See [LICENSE](https://github.com/tothenew/terraform-aws-template/blob/main/LICENSE) for full details.