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

module "storage2" {
  source = "./modules/storage_account"

  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  tags                = var.tags
}

data "azurerm_client_config" "default" {}
