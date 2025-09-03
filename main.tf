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

# This ensures we have unique CAF compliant names for our resources.
module "naming" {
  source  = "Azure/naming/azurerm"
  version = "0.4.0"
}

resource "azurerm_container_app_environment" "this" {
  location            = azurerm_resource_group.default.location
  name                = module.naming.container_app_environment.name_unique
  resource_group_name = azurerm_resource_group.default.name
}

# This is the module call
module "container_app" {
  source = "Azure/avm-res-app-containerapp/azurerm"

  container_app_environment_resource_id = azurerm_container_app_environment.this.id
  name                                  = module.naming.container_app.name_unique
  resource_group_name                   = azurerm_resource_group.default.name
  template = {
    containers = [{
      image  = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
      name   = "containerapps-helloworld"
      cpu    = "0.25"
      memory = "0.5Gi"
    }]
    min_replicas    = 0
    max_replicas    = 1
    cooldown_period = 60
  }
  enable_telemetry = false
  ingress = {
    external_enabled = true
    target_port      = 80
    traffic_weight = [{
      latest_revision = true
      percentage      = 100
    }]
  }
  revision_mode = "Single"
}
