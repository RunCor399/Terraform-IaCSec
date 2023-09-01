
variable "azure_sp_key" {}

variable "credentials" {
  description = "Azure Service Provider Credentials"
  type        = map(string)
  default = {
    subscription_id = "8eb30f69-69f6-4ff0-99ea-f9edd2274036"
    tenant_id       = "2a05ac92-2049-4a26-9b34-897763efc8e2"
    client_id       = "12d6c386-4977-4aea-9b56-902c514c9d14"
  }
}


variable "mysql_db_resource_group" {
  description = "Azure MySQL DB Resource Group Info"
  type        = map(string)
  default = {
    name = "mysql-db-resource-group"
    location = "UK South"
  }
}


