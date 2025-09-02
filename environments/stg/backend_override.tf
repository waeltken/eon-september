terraform {
  backend "azurerm" {
    resource_group_name  = "default"
    storage_account_name = "tfstatecwcontoso"
    container_name       = "tfstate"
    key                  = "eon-september-stg.tfstate"
  }
}
