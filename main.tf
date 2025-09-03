provider "azurerm" {
  subscription_id = "eedea4b7-9139-440d-84b1-0b09522f109e"

  # Important for security policy on Microsoft Tenant
  storage_use_azuread = true

  features {}
}

variable "location" {
  type        = string
  default     = "Germany West Central"
  description = "The Azure region to deploy resources in."
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "The environment name to deploy resources in."
}

variable "tags" {
  type = map(string)
  default = {
    environment = "development"
    team        = "eon2"
  }
  description = "A map of tags to assign to the resource."
}

resource "azurerm_resource_group" "default" {
  name     = "eon-september-${var.environment}-rg"
  location = var.location

  tags = var.tags
}

module "storage1" {
  source = "./modules/storage_account"

  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  tags                = var.tags
}

data "azurerm_client_config" "default" {}

output "resource_group_name" {
  value = azurerm_resource_group.default.name
}

output "storage_account_name" {
  value = module.storage1.storage_account_name
}
