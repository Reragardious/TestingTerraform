# STEP 1) Resource Group Creation: GlobalTrust Bank establishes a dedicated resource group 
# named "GlobalTrustRG" to streamline the management of their Azure resources, 
# ensuring operational efficiency, cost optimization, and regulatory compliance 
# across their global operations.
# resource "azurerm_resource_group" "gtb_rg" {
#  name     = "GlobalTrustRG"
#  location = var.resource_group_location
# }


# STEP 2) Virtual Network Setup: To ensure secure and reliable communication between banking applications, 
# services, and databases, GlobalTrust Bank deploys a robust virtual network, "GlobalTrustVNet," 
# within their Azure environment. This network architecture facilitates seamless connectivity, 
# data integrity, and access control enforcement, while also enabling global scalability and compliance with local regulation

#Create a Virtual Network
resource "azurerm_virtual_network" "GTBVNet" {
  name                = "GlobalTrustVNet"
  address_space       = ["10.0.0.0/16"]
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
}

# STEP 3)       Subnet Configuration: Within the virtual network, GlobalTrust Bank configures 
# multiple subnets tailored to their specific banking operations and security requirements:
# •     Customer-Facing Subnet: Hosts GlobalTrust Bank's online banking portal, mobile banking applications, and customer service platforms, providing customers with secure access to account information, transactions, and financial services.
# •     Backend Subnet: Houses GlobalTrust Bank's core banking systems, including databases, transaction processing engines, and risk management platforms, responsible for managing banking operations, processing transactions, and ensuring compliance with regulatory standards.
# •     Security Subnet: Serves as a dedicated subnet for security infrastructure components, such as intrusion detection systems, firewalls, and security monitoring tools, ensuring continuous protection against cyber threats and unauthorized access.

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


# STEP 4) Load Balancer Deployment: To ensure high availability and optimal performance of 
# their banking services, GlobalTrust Bank deploys a load balancer, "GlobalTrustLB," 
# within the security subnet. By assigning a new public IP address to the load balancer, GlobalTrust Bank optimizes traffic distribution, mitigates potential service disruptions, and enhances overall system resilience

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

# STEP 5) Storage Account Creation: Recognizing the critical importance of data storage, 
# management, and regulatory compliance, GlobalTrust Bank establishes a centralized storage 
# solution, "globaltruststorage," to securely store sensitive financial data, transaction logs, 
# and regulatory documentation. This storage account is designed to meet stringent regulatory 
# requirements, including data encryption, retention policies, and audit trails, 
# while also enabling global accessibility and scalability.

resource "azurerm_storage_account" "globaltruststorage" {
  name                     = "globaltruststorage"
  resource_group_name      = var.resource_group_name
  location                 = var.resource_group_location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# STEP 6) Virtual Machine Deployment: GlobalTrust Bank deploys virtual machines configured 
# to support their banking applications, backend services, and regulatory compliance 
# workflows. These virtual machines are strategically placed within an availability set, 
# "GlobalTrustAS," to ensure fault tolerance, minimize downtime, and maintain 
# service continuity in the event of hardware failures or system maintenance.

# create managed disk
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

  #virtual machine requires os_disk
  storage_os_disk {
    name          = "osDisk9876"
    caching       = "ReadWrite"
    create_option = "Attach"
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


# STEP 7) Storage Account Container Creation: Within the "globaltruststorage" account, 
# GlobalTrust Bank creates dedicated containers to securely store sensitive banking data, 
# transaction records, and regulatory documentation. These containers are designed to optimize 
# data management, access controls, and compliance with industry regulations, ensuring the 
# integrity and confidentiality of customer information across global operations.

resource "azurerm_storage_container" "gtb_storage_container" {
  name                  = "gtb-storage-container"
  storage_account_name  = azurerm_storage_account.globaltruststorage.name
  container_access_type = "private"
}

# STEP 8) Network Interface Card Setup: To facilitate secure communication and data transfer,
# GlobalTrust Bank provisions network interface cards (NICs) for their virtual 
# machines and connects them to the respective subnets within the GlobalTrustVNet. 
# This setup ensures efficient network connectivity, data isolation, and compliance 
# with regulatory standards, enabling GlobalTrust Bank to maintain the highest standards 
# of security and reliability for their banking operations worldwide.

# customer facing NIC
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

# backend NIC
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

# security NIC
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

