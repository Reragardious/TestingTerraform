# Creating Storage Account & Container for the backend

#Create storage account for backend
resource "azurerm_storage_account" "gtb_backend_storage" {
  name                     = "gtbbackendstorage"
  resource_group_name      = var.resource_group_name
  location                 = var.resource_group_location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

#Create storage account in container for backend
resource "azurerm_storage_container" "gtb_backend_container" {
  name                  = "gtb-backend-container"
  storage_account_name  = azurerm_storage_account.gtb_backend_storage.name
  container_access_type = "private"
}
