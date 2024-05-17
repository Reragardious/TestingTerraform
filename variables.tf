# to create variables that will be called in backend.tf and main.tf

#Create variable for Resource Group's location
variable "resource_group_location" {
  type        = string
  default     = "<ADD YOUR RESOURCE GROUP LOCATION>"
  description = "Location of the resource group."
}
# how to call - var.resource_group_location

#Create variable for for the Resource Group's name
variable "resource_group_name" {
  type        = string
  default     = "<ADD YOUR RESOURCE GROUP NAME>"
  description = "The resource group provided by the Cloud Guru Sandbox."
}
