terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.52.0"
    }

    azapi = {
      source  = "azure/azapi"
      version = "1.6.0"
    }
  }

  backend "azurerm" {
    resource_group_name = "terraform"
    storage_account_name = "terraformstate1603709092"
    container_name = "tfstate"
    key = "terraform.tfstate_keycloak_app"
  }
}

provider "azapi" {
  
}


provider "azurerm" {
  subscription_id = var.credentials["subscription_id"]
  client_id       = var.credentials["client_id"]
  client_secret   = var.azure_sp_key
  tenant_id       = var.credentials["tenant_id"]
  features {}
}


resource "azurerm_resource_group" "keycloak-resource-group" {
  name = var.keycloak-resource-group.name
  location = var.keycloak-resource-group.location
}