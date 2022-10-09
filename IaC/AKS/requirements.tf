resource "azurerm_resource_group" "rg" {
  count    = var.create_requirements ? 1 : 0
  name     = "${var.prefix}-rg"
  location = var.region
}

resource "azurerm_virtual_network" "vnet" {
  count               = var.create_requirements ? 1 : 0
  name                = "${var.prefix}-vnet"
  location            = var.region
  resource_group_name = azurerm_resource_group.rg[count.index].name
  address_space       = ["10.0.0.0/16"]
  subnet {
    name           = "${var.prefix}-subnet"
    address_prefix = "10.0.0.0/22"
  }
}

data "azuread_client_config" "current" {}

resource "azuread_service_principal" "sp" {
  count          = var.create_requirements ? 1 : 0
  application_id = azuread_application.app[count.index].application_id
  owners         = [data.azuread_client_config.current.object_id]
}

resource "azuread_application" "app" {
  count        = var.create_requirements ? 1 : 0
  display_name = "${var.prefix}-app"
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal_password" "sp_pwd" {
  count                = var.create_requirements ? 1 : 0
  service_principal_id = azuread_service_principal.sp[count.index].object_id
}

resource "azurerm_role_assignment" "sp_role" {
  count                = var.create_requirements ? 1 : 0
  scope                = azurerm_resource_group.rg[count.index].id
  role_definition_name = "Reader"
  principal_id         = azuread_service_principal.sp[count.index].id
}

output "sp_secrets" {
  value = {
    clientId       = var.create_requirements ? azuread_service_principal.sp[0].application_id : null
    clientSecret   = var.create_requirements ? azuread_service_principal_password.sp_pwd[0].value : null
    subscriptionId = var.subscription_id
    tenantId       = var.create_requirements ? azuread_service_principal.sp[0].application_tenant_id : null
  }
  sensitive = true
}
