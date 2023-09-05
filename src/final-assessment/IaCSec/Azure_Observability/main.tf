terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.52.0"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.15.0"
    }
  }

  backend "azurerm" {
    resource_group_name = "terraform-rg"
    storage_account_name = "terraformbackendmanuel"
    container_name = "tfstate"
    key = "terraform.tfstate_observability"
  }
}


provider "azurerm" {
  subscription_id = var.credentials["subscription_id"]
  client_id       = var.credentials["client_id"]
  client_secret   = var.azure_sp_key
  tenant_id       = var.credentials["tenant_id"]
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

resource "azurerm_resource_group" "observability_rg" {
  name = var.observability_rg.name
  location = var.observability_rg.location
}