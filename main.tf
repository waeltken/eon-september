provider "azurerm" {
  subscription_id = "eedea4b7-9139-440d-84b1-0b09522f109e"

  features {}
}

resource "random_string" "suffix" {
  length  = 4
  upper   = false
  special = false
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

resource "azurerm_storage_account" "default" {
  name                     = "eonseptembersa${random_string.suffix.result}"
  location                 = azurerm_resource_group.default.location
  resource_group_name      = azurerm_resource_group.default.name
  account_tier             = "Standard"
  account_replication_type = "LRS"

  allow_nested_items_to_be_public = false

  tags = var.tags
}

resource "azurerm_storage_container" "state" {
  name                  = "tfstate"
  storage_account_id    = azurerm_storage_account.default.id
  container_access_type = "private"
}

data "azurerm_client_config" "default" {}

output "resource_group_name" {
  value = azurerm_resource_group.default.name
}

output "storage_account_name" {
  value = azurerm_storage_account.default.name
}
