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
    key = "terraform.tfstate_aks"
  }
}


provider "azurerm" {
  subscription_id = var.credentials["subscription_id"]
  client_id       = var.credentials["client_id"]
  #client_secret   = var.azure_sp_key
  client_secret = "uny8Q~ILMQkgh5P7t_siumASCm0N.SU6kPNBmdnT"
  tenant_id       = var.credentials["tenant_id"]
  features {}
}


resource "azurerm_resource_group" "aks_resource_group" {
  name = var.aks_resource_group.name
  location = var.aks_resource_group.location
}







