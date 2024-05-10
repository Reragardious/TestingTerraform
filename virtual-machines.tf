#Create a network interface for the virtual machine below
resource "azurerm_network_interface" "networkinterfacemain" {
  name                = "networkinterfaceglobal783"
  location            = "East US"
  resource_group_name = "1-0ebe8a23-playground-sandbox"

  ip_configuration {
    name                          = "testconfiguration"
    subnet_id                     = back_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

#Create a virtual machine
resource "azurerm_virtual_machine" "main" {
  name                  = "globaltrust_bank_vm"
  location              = "East US"
  resource_group_name   = "1-0ebe8a23-playground-sandbox"
  vm_size               = "Standard_DS1_v2"
  network_interface_ids = azurerm_network_interface.networkinterfacemain.id
  #virtual machine requires os_disk

  os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
}

#Create an Availability Set
resource "azurerm_availability_set" "availabilitysetforvm" {
  name                = "gloabltrustbankavailset"
  location            = "East US"
  resource_group_name = "1-0ebe8a23-playground-sandbox"
}
