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

resource "azurerm_container_app" "default" {
  container_app_environment_id = azurerm_container_app_environment.this.id
  name                         = module.naming.container_app.name_unique
  resource_group_name          = azurerm_resource_group.default.name
  revision_mode                = "Single"

  template {
    container {
      image = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
      name  = "hello-world"

      cpu    = "0.25"
      memory = "0.5Gi"
    }
    max_replicas = 1
    min_replicas = 0
  }

  ingress {
    target_port      = 80
    external_enabled = true

    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }
}
