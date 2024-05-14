#ERROR Ip Configurations On Same Nic Cannot Use Different Subnets UNDER Network Interface


#Create a Resource Group
#Unable to create a Resource Group, so will use the provided one from the sandbox
#resource "azurerm_resource_group" "GlobalTrust" {
#  name     = "GlobalTrust"
#  location = "East US"
#}


#Create a Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "globaltrust_banktesting"
  address_space       = ["10.0.0.0/16"]
  location            = "East US"
  resource_group_name = "1-2d6d45b3-playground-sandbox"
}

#Create a subnet for frontened
resource "azurerm_subnet" "front_subnet" {
  name                 = "globaltrust_bank_frontend_subnet"
  resource_group_name  = "1-2d6d45b3-playground-sandbox"
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes       = ["10.0.128.0/18"]
}

#Create a subnet for middle
resource "azurerm_subnet" "middle_subnet" {
  name                 = "globaltrust_bank_middle_subnet"
  resource_group_name  = "1-2d6d45b3-playground-sandbox"
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes       = ["10.0.0.0/18"]
}

#Create a subnet for backend
resource "azurerm_subnet" "back_subnet" {
  name                 = "globaltrust_bank_backend_subnet"
  resource_group_name  = "1-2d6d45b3-playground-sandbox"
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes       = ["10.0.64.0/18"]
}

#Output so it can be referenced to in virtual-machines.tf
output "back_subnet_id" {
  value = azurerm_subnet.back_subnet.id
}

#Create a new public ip
resource "azurerm_public_ip" "publicip" {
  name                = "publicIpForLb"
  #Can use location variable for location below
  location            = "East US"
  resource_group_name = "1-2d6d45b3-playground-sandbox"
  allocation_method   = "Static"
}

#Create a load balancer & connect to public ip
resource "azurerm_lb" "LoadBalancer" {
    name = "globaltrust_bank_loadBalancer"
    location = "East US"    
    resource_group_name = "1-2d6d45b3-playground-sandbox"

    frontend_ip_configuration {
        name = "PublicIpConnectedto"
        public_ip_address_id = azurerm_public_ip.publicip.id
    }
}

#Create a Storage Account
resource "azurerm_storage_account" "storageAccount" {
  #name must be lowercase and numbers and between 3 and 24
  name                     = "globalbank582034account"
  resource_group_name      = "1-2d6d45b3-playground-sandbox"
  location                 = "East US"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}



#Creating network interface, virtual machine, and availability set below

#Create a network interface for the virtual machine below
resource "azurerm_network_interface" "networkinterfacemain" {
  name                = "networkinterfaceglobal783"
  location            = "East US"
  resource_group_name = "1-2d6d45b3-playground-sandbox"

  #ERROR: Ip Configurations On Same Nic Cannot Use Different Subnets:

  ip_configuration {
    name                          = "IPsubnetFront"
    subnet_id                     = azurerm_subnet.front_subnet.id
    private_ip_address_allocation = "Dynamic"
    #Must be true for the first ip_configuration when multiple are specified.
    primary = "true"
  }
  ip_configuration {
    name                          = "IPsubnetMiddle"
    #Referenced the output for back_subnet 
    subnet_id                     = azurerm_subnet.middle_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
  ip_configuration {
    name                          = "IPsubnetBack"
    #Referenced the output for back_subnet 
    subnet_id                     = azurerm_subnet.back_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

#Create a virtual machine
resource "azurerm_virtual_machine" "main" {
  name                  = "globaltrust_bank_vm"
  location              = "East US"
  resource_group_name   = "1-2d6d45b3-playground-sandbox"
  vm_size               = "Standard_DS1_v2"
  network_interface_ids = [azurerm_network_interface.networkinterfacemain.id]

  #virtual machine requires os_disk
  # ERRORS accuring with virtual machine relating storage_os_disk:
  # ERROR:"Cannot specify user image overrides for a disk already defined in the specified image reference."
  storage_os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
}

#Create an Availability Set
resource "azurerm_availability_set" "availabilitysetforvm" {
  name                = "gloabltrustbankavailset"
  location            = "East US"
  resource_group_name = "1-2d6d45b3-playground-sandbox"
}
