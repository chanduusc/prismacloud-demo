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
