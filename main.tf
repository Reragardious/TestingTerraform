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
resource "azurerm_subnet" "front_subnet" {
  name                 = "globaltrust_bank_frontend_subnet"
  resource_group_name  = "1-0ebe8a23-playground-sandbox"
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes       = ["10.0.128.0/18"]
}

#Create a subnet for middle
resource "azurerm_subnet" "middle_subnet" {
  name                 = "globaltrust_bank_middle_subnet"
  resource_group_name  = "1-0ebe8a23-playground-sandbox"
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes       = ["10.0.0.0/18"]
}

#Create a subnet for backend
resource "azurerm_subnet" "back_subnet" {
  name                 = "globaltrust_bank_backend_subnet"
  resource_group_name  = "1-0ebe8a23-playground-sandbox"
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes       = ["10.0.64.0/18"]
}

#Create a new public ip
resource "azurerm_public_ip" "publicip" {
  name                = "publicIpForLb"
  #Can use location variable for location below
  location            = "East US"
  resource_group_name = "1-0ebe8a23-playground-sandbox"
  allocation_method   = "Static"
}

#Create a load balancer & connect to public ip
resource "azurerm_lb" "LoadBalancer" {
    name = "globaltrust_bank_loadBalancer"
    location = "East US"    
    resource_group_name = "1-0ebe8a23-playground-sandbox"

    frontend_ip_configuration {
        name = "PublicIpConnectedto"
        public_ip_address_id = azurerm_public_ip.publicip.id

    }
}

#Create a Storage Account
resource "azurerm_storage_account" "storageAccount" {
  #name must be lowercase and numbers and between 3 and 24
  name                     = "GlobalTrust_StorageForVMs_more"
  resource_group_name      = "1-0ebe8a23-playground-sandbox"
  location                 = "East US"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
