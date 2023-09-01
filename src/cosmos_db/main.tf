terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.52.0"
    }
  }

  backend "azurerm" {
    resource_group_name = "terraform"
    storage_account_name = "terraformstate1603709092"
    container_name = "tfstate"
    key = "terraform.tfstate_cosmos_db"
  }
}


provider "azurerm" {
  subscription_id = var.credentials["subscription_id"]
  client_id       = var.credentials["client_id"]
  client_secret   = var.azure_sp_key
  tenant_id       = var.credentials["tenant_id"]
  features {}
}


resource "azurerm_resource_group" "cosmos_db_resource_group" {
  name = var.cosmos_db_resource_group.name
  location = var.cosmos_db_resource_group.location
}








