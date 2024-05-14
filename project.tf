
# STEP 2) Virtual Network Setup: To ensure secure and reliable communication between banking applications, 
# services, and databases, GlobalTrust Bank deploys a robust virtual network, "GlobalTrustVNet," 
# within their Azure environment. This network architecture facilitates seamless connectivity, 
# data integrity, and access control enforcement, while also enabling global scalability and compliance with local regulation

#Create a Virtual Network
resource "azurerm_virtual_network" "GlobalTrustVNet" {
  name                = "GlobalTrustVNet"
  address_space       = ["10.0.0.0/16"]
  location            = "West US"
  resource_group_name = "1-2d6d45b3-playground-sandbox"
}

# STEP 3)	Subnet Configuration: Within the virtual network, GlobalTrust Bank configures 
# multiple subnets tailored to their specific banking operations and security requirements:
# •	Customer-Facing Subnet: Hosts GlobalTrust Bank's online banking portal, mobile banking applications, and customer service platforms, providing customers with secure access to account information, transactions, and financial services.
# •	Backend Subnet: Houses GlobalTrust Bank's core banking systems, including databases, transaction processing engines, and risk management platforms, responsible for managing banking operations, processing transactions, and ensuring compliance with regulatory standards.
# •	Security Subnet: Serves as a dedicated subnet for security infrastructure components, such as intrusion detection systems, firewalls, and security monitoring tools, ensuring continuous protection against cyber threats and unauthorized access.



# STEP 4) Load Balancer Deployment: To ensure high availability and optimal performance of 
# their banking services, GlobalTrust Bank deploys a load balancer, "GlobalTrustLB," 
# within the security subnet. By assigning a new public IP address to the load balancer, GlobalTrust Bank optimizes traffic distribution, mitigates potential service disruptions, and enhances overall system resilience



# STEP 5) Storage Account Creation: Recognizing the critical importance of data storage, 
# management, and regulatory compliance, GlobalTrust Bank establishes a centralized storage 
# solution, "globaltruststorage," to securely store sensitive financial data, transaction logs, 
# and regulatory documentation. This storage account is designed to meet stringent regulatory 
# requirements, including data encryption, retention policies, and audit trails, 
# while also enabling global accessibility and scalability.



# STEP 7) Storage Account Container Creation: Within the "globaltruststorage" account, 
# GlobalTrust Bank creates dedicated containers to securely store sensitive banking data, 
# transaction records, and regulatory documentation. These containers are designed to optimize 
# data management, access controls, and compliance with industry regulations, ensuring the 
# integrity and confidentiality of customer information across global operations.


