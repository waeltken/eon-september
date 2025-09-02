terraform {
  backend "azurerm" {
    resource_group_name  = "eon-september-rg-aals"
    storage_account_name = "eonseptembersaaals"
    container_name       = "tfstate"
    key                  = "eon-september-dev.tfstate"
  }
}
