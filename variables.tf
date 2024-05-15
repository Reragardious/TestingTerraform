# to create variables that will be called in project.tf

# for Resource Group's location - This wil be used for all locations
variable "resource_group_location" {
  type        = string
  default     = "East US"
  description = "Location of the resource group."
}
# how to call - var.resource_group_location

# for the Resource Group name, change default to the current resource group name
variable "resource_group_name" {
  type        = string
  default     = "1-bd0b7857-playground-sandbox"
  description = "The resource group provided by Cloud Guru Sandbox."
}
