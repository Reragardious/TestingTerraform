
resource "azurerm_storage_account" "gtb_backend_storage" {
  name                     = "backend_storage"
  resource_group_name      = var.resource_group_name
  location                 = var.resource_group_location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "gtb_backend_container" {
  name                  = "gtb-backend-container"
  storage_account_name  = azurerm_storage_account.gtb_backend_storage.name
  container_access_type = "private"
}
