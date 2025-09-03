provider "azurerm" {
  subscription_id = "eedea4b7-9139-440d-84b1-0b09522f109e"

  # Important for security policy on Microsoft Tenant
  storage_use_azuread = true

  features {}
}
