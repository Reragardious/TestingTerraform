#Create a Resource Group
#Unable to create a Resource Group, so will use the provided one from the sandbox

#Create a Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "GlobalTrust Bank"
  address_space       = ["10.0.0.0/16"]
  location            = "East US"
  resource_group_name = "1-0ebe8a23-playground-sandbox"
}