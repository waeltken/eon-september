variable "location" {
  type        = string
  default     = "Germany West Central"
  description = "The Azure region to deploy resources in."
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "The environment name to deploy resources in."
}

variable "tags" {
  type = map(string)
  default = {
    environment = "development"
    team        = "eon2"
  }
  description = "A map of tags to assign to the resource."
}
