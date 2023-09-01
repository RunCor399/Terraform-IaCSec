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


variable "observability_rg" {
  description = "Observavility Resource Group"
  type        = map(string)
  default = {
    name     = "observability_rg"
    location = "westeurope"
  }
}

variable "log-analytics-workspace" {
    type = map(string)
    default = {
        name = "log-analytics-workspace"
        location = "westeurope"
    }
}

variable "grafana-dashboard" {
    type = map(string)
    default = {
        name = "grafana-dashboard"
        location = "westeurope"
    }
}
