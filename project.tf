
# STEP 2) Virtual Network Setup: To ensure secure and reliable communication between banking applications, 
# services, and databases, GlobalTrust Bank deploys a robust virtual network, "GlobalTrustVNet," 
# within their Azure environment. This network architecture facilitates seamless connectivity, 
# data integrity, and access control enforcement, while also enabling global scalability and compliance with local regulation

#Create a Virtual Network
resource "azurerm_virtual_network" "GlobalTrustVNet" {
  name                = "GlobalTrustVNet"
  address_space       = ["10.0.0.0/16"]
  location            = "East US"
  resource_group_name = "1-2d6d45b3-playground-sandbox"
}
