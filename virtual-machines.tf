#Create a virtual machine
resource "azurerm_virtual_machine" "main" {
  name                  = "globaltrust_bank_vm"
  location              = "East US"
  resource_group_name   = "1-0ebe8a23-playground-sandbox"
  vm_size               = "Standard_DS1_v2"
}

#Create an Availability Set
resource "azurerm_availability_set" "availabilitysetforvm" {
  name                = "gloabltrustbankavailset"
  location            = "East US"
  resource_group_name = "1-0ebe8a23-playground-sandbox"
}
