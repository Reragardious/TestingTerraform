# STEP 1) Resource Group Creation

#Create a resource group
 resource "azurerm_resource_group" "gtb_rg" {
  name     = "GlobalTrustRG"
  location = var.resource_group_location
}


# STEP 2) Virtual Network Setup

#Create a virtual network
resource "azurerm_virtual_network" "GTBVNet" {
  name                = "GlobalTrustVNet"
  address_space       = ["10.0.0.0/16"]
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
}

# STEP 3) Subnet Configuration

#Create a subnet for customer-facing
resource "azurerm_subnet" "customer_subnet" {
  name                 = "gtb_customer_facing_subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.GTBVNet.name
  address_prefixes     = ["10.0.128.0/18"]
}

#Create a subnet for security 
resource "azurerm_subnet" "security_subnet" {
  name                 = "gtb_security_subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.GTBVNet.name
  address_prefixes     = ["10.0.0.0/18"]
}

#Create a subnet for backend
resource "azurerm_subnet" "backend_subnet" {
  name                 = "gtb_backend_subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.GTBVNet.name
  address_prefixes     = ["10.0.64.0/18"]
}


# STEP 4) Load Balancer Deployment

#Create a public ip
resource "azurerm_public_ip" "publicip" {
  name = "gtb_publicIpForLB"
  #Can use location variable for location below
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
}

resource "azurerm_lb" "gtb_LoadBalancer" {
  name                = "GlobalTrustLB"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  frontend_ip_configuration {
    name                 = "ConnectionPoint_LB"
    public_ip_address_id = azurerm_public_ip.publicip.id
  }
}

# STEP 5) Storage Account Creation

#Create storage account
resource "azurerm_storage_account" "globaltruststorage" {
  name                     = "globaltruststorage"
  resource_group_name      = var.resource_group_name
  location                 = var.resource_group_location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# STEP 6) Virtual Machine Deployment

# create managed disk for storage_os_disk in virtual machine
resource "azurerm_managed_disk" "osdisk" {
  name                 = "osDisk9876"
  location             = var.resource_group_location
  resource_group_name  = var.resource_group_name
  storage_account_type = "StandardSSD_LRS"
  create_option        = "Empty"
  disk_size_gb         = "4"
}

#Create a virtual machine
resource "azurerm_virtual_machine" "gtb_vm" {
  name                  = "globaltrust_bank_vm"
  location              = var.resource_group_location
  resource_group_name   = var.resource_group_name
  vm_size               = "Standard_DS1_v2"
  primary_network_interface_id = azurerm_network_interface.networkinterfacebackend.id
  network_interface_ids = [azurerm_network_interface.networkinterfacesecurity.id]

  storage_os_disk {
    name          = "osDisk9876"
    caching       = "ReadWrite"
    create_option = "Attach"
    #  managed_disk_type = "StandardSSD_LRS"
    managed_disk_id = azurerm_managed_disk.osdisk.id
    os_type = "Linux"
  }
}

#Create an Availability Set
resource "azurerm_availability_set" "availabilitysetforvm" {
  name                = "gloabltrustbankavailset"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
}


# STEP 7) Storage Account Container Creation

#Create storage container in storage account
resource "azurerm_storage_container" "gtb_storage_container" {
  name                  = "gtb-storage-container"
  storage_account_name  = azurerm_storage_account.globaltruststorage.name
  container_access_type = "private"
}

# STEP 8) Network Interface Card Setup

#Create customer facing NIC
resource "azurerm_network_interface" "networkinterfacecustomer" {
  name                = "gtb_nic_customer"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "gtb_customer_facing_ip"
    subnet_id                     = azurerm_subnet.customer_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

#Create backend NIC
resource "azurerm_network_interface" "networkinterfacebackend" {
  name                = "gtb_nic_backend"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "gtb_backend_ip"
    subnet_id                     = azurerm_subnet.backend_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

#Create security NIC
resource "azurerm_network_interface" "networkinterfacesecurity" {
  name                = "gtb_nic_security"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "gtb_security_ip"
    subnet_id                     = azurerm_subnet.security_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}
