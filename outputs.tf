output "resource_group_name" {
  value = azurerm_resource_group.default.name
}

output "storage_account_name1" {
  value = module.storage1.storage_account_name
}

output "storage_account_name2" {
  value = module.storage2.storage_account_name
}
