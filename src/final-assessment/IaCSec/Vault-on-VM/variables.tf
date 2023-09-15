# ---------------------------
# Azure Key Vault
# ---------------------------
variable "tenant_id" {
  default = ""
}

variable "key_name" {
  description = "Azure Key Vault key name"
  default     = "generated-key"
}

variable "location" {
  description = "Azure location where the Key Vault resource to be created"
  default     = "uksouth"
}

variable "resource_group_name" {
  type = string
  default = "vault-vm-rg"
}


# ---------------------------
# Virtual Machine
# ---------------------------
variable "public_key" {
  default = ""
}

variable "subscription_id" {
  default = ""
}

variable "client_id" {
  default = ""
}

variable "client_secret" {
  default = ""
}

variable "vm_name" {
  default = "vault-vm"
}

variable "vault_version" {
  # NB execute `apt-cache madison vault` to known the available versions.
  default = "1.9.4"
}

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

