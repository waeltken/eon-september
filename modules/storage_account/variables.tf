variable "tags" {
  type        = map(string)
  description = "Tags to be applied to resources"
  default     = {}
}

variable "location" {
  type        = string
  description = "The Azure region to deploy resources in."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the storage account."
}
