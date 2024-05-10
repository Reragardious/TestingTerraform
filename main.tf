#Create a Resource Group
#Unable to create a Resource Group, so will use the provided one from the sandbox

#Create a Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "globaltrust_banktesting"
  address_space       = ["10.0.0.0/16"]
  location            = "East US"
  resource_group_name = "1-0ebe8a23-playground-sandbox"
}

#Create a subnet for frontened
resource "azurerm_subnet" "subnet" {
  name                 = "globaltrust_bank_frontend_subnet"
  resource_group_name  = "1-0ebe8a23-playground-sandbox"
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes       = ["10.0.1.0/24"]
}

#Create a subnet for middle
resource "azurerm_subnet" "subnet" {
  name                 = "globaltrust_bank_middle_subnet"
  resource_group_name  = "1-0ebe8a23-playground-sandbox"
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes       = ["10.0.1.0/24"]
}

#Create a subnet for backend
resource "azurerm_subnet" "subnet" {
  name                 = "globaltrust_bank_backend_subnet"
  resource_group_name  = "1-0ebe8a23-playground-sandbox"
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes       = ["10.0.1.0/24"]
}
