resource "azurerm_storage_account" "storage_acc" {
  # checkov:skip=CKV_AZURE_59: Public network access required for demo bucket
  # checkov:skip=CKV2_AZURE_18: No CMK needed for demo bucket
  # checkov:skip=CKV2_AZURE_1: No CMK needed for demo bucket
  # checkov:skip=CKV_AZURE_33: No logging needed for demo bucket
  count                    = var.create_storage ? 1 : 0
  name                     = "${random_string.password.result}cnappdemo"
  resource_group_name      = var.create_requirements ? azurerm_resource_group.rg[0].name : var.resource_group_name
  account_replication_type = "LRS"
  location                 = var.region
  account_tier             = "Standard"
  min_tls_version          = "TLS1_2"
  tags = {
    yor_trace = "8223b435-54b1-4b7d-b827-5438120bb59b"
  }
}

resource "azurerm_storage_container" "storage_container" {
  # checkov:skip=CKV_AZURE_34: Public access needed for demo purposes
  # checkov:skip=CKV2_AZURE_21: No logging needed for demo bucket
  count                 = var.create_storage ? 1 : 0
  name                  = "${random_string.password.result}cnappdemo"
  container_access_type = "blob"
  storage_account_name  = azurerm_storage_account.storage_acc[0].name
}

resource "azurerm_role_assignment" "storage_blob_data_owner_user" {
  count                = var.create_storage ? 1 : 0
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = data.azuread_client_config.current.object_id
  scope                = azurerm_storage_account.storage_acc[0].id
}

resource "azurerm_role_assignment" "storage_blob_data_owner_pod" {
  count                = var.create_storage ? 1 : 0
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = azurerm_user_assigned_identity.cnappdemo.principal_id
  scope                = azurerm_storage_account.storage_acc[0].id
}
