variable "azure_sp_key" {}

variable "credentials" {
  description = "Azure Service Provider Credentials"
  type        = map(string)
  default = {
    subscription_id = "945fc713-dc5d-4ba6-9b6b-2f1fb2225b19"
    tenant_id       = "c5179d57-9fa0-4d70-bf82-c3e49fc377d9"
    client_id       = "8267d52d-29b9-4a06-ac44-1c6743c8b010"
  }
}

# Politecnico Account
# subscription_id: "8eb30f69-69f6-4ff0-99ea-f9edd2274036"
# tenant_id: "2a05ac92-2049-4a26-9b34-897763efc8e2"
# client_id: "12d6c386-4977-4aea-9b56-902c514c9d14"


# Reply Account
# subscription id: 945fc713-dc5d-4ba6-9b6b-2f1fb2225b19
# tenant id: c5179d57-9fa0-4d70-bf82-c3e49fc377d9
# client id: 8267d52d-29b9-4a06-ac44-1c6743c8b010



variable "keycloak-resource-group" {
  description = "Azure AKS Resource Group Info"
  type        = map(string)
  default = {
    name     = "keycloak-resource-group"
    location = "francecentral"
  }
}