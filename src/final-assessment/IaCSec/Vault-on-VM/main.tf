# see https://github.com/hashicorp/terraform
terraform {
  required_version = ">= 1.1.7"
  required_providers {
    template = "~> 2.2.0"
    random = "~> 3.1.2"
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.52.0"
    }
    azuread = "~> 2.29.0"
  }

  backend "azurerm" {
    resource_group_name = "terraform"
    storage_account_name = "terraformstate1603709092"
    container_name = "tfstate"
    key = "terraform.tfstate_vault_vm"
  }
}

# see https://github.com/terraform-providers/terraform-provider-azurerm
provider "azurerm" {
  subscription_id = var.credentials["subscription_id"]
  client_id       = var.credentials["client_id"]
  client_secret   = var.azure_sp_key
  tenant_id       = var.credentials["tenant_id"]
  features {}
}




resource "azurerm_resource_group" "vault" {
  name     = var.resource_group_name
  location = var.location
}

resource "random_id" "keyvault" {
  byte_length = 4
}

data "azurerm_client_config" "current" {
}

data "azuread_service_principal" "vault" {
  application_id = var.client_id
}

############################
 # CERTIFICATES
############################

resource "tls_private_key" "private" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "tls_self_signed_cert" "cert" {
  private_key_pem = tls_private_key.private.private_key_pem
  validity_period_hours = 87600

  # Reasonable set of uses for a server SSL certificate.
  allowed_uses = [
      "key_encipherment",
      "digital_signature",
      "server_auth",
  ]

  ip_addresses = [
    "127.0.0.1"
  ]

  dns_names = ["${azurerm_key_vault.vault.name}.${var.location}.azurecontainer.io"]

  subject {
      common_name  = "${azurerm_key_vault.vault.name}.${var.location}.azurecontainer.io"
      organization = "Test Organization, Inc"
  }
}

resource "local_file" "key" {
    content     = tls_private_key.private.private_key_pem
    filename = "${path.module}/vault-cert.key"
} 

resource "local_file" "cert" {
    content     = tls_self_signed_cert.cert.cert_pem
    filename = "${path.module}/vault-cert.crt"
} 



 ###########################
 # VAULT
 ###########################

resource "azurerm_key_vault" "vault" {
  name                = "azure-vault-${random_id.keyvault.hex}"
  location            = azurerm_resource_group.vault.location
  resource_group_name = azurerm_resource_group.vault.name
  tenant_id           = var.tenant_id
  public_network_access_enabled = false
  purge_protection_enabled = true
  soft_delete_retention_days  = 7

  # enable virtual machines to access this key vault.
  # NB this identity is used in the example /tmp/azure_auth.sh file.
  #    vault is actually using the vault service principal.
  enabled_for_deployment = true

  sku_name = "standard"

  # access policy for the hashicorp vault service principal.
  access_policy {
    tenant_id = var.tenant_id
    object_id = data.azuread_service_principal.vault.object_id

    key_permissions = [
      "Get", "List", "Create", "Delete", "Update", "WrapKey", "UnwrapKey", "GetRotationPolicy", "Purge",
    ]
  }

  # access policy for the user that is currently running terraform.
  access_policy {
    tenant_id = var.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get", "List", "Create", "Delete", "Update", "WrapKey", "UnwrapKey", "GetRotationPolicy", "Purge",
    ]
  }

  # TODO does this really need to be so broad? can it be limited to the vault vm?
  # network_acls {
  #   default_action = "Allow"
  #   bypass         = "AzureServices"
  # }

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
    virtual_network_subnet_ids = [
      azurerm_subnet.tf_subnet.id
    ]
  }
}

# TODO the "generated" resource name is not very descriptive; why not use "vault" instead?
# hashicorp vault will use this azurerm_key_vault_key to wrap/encrypt its master key.
resource "azurerm_key_vault_key" "generated" {
  name         = var.key_name
  key_vault_id = azurerm_key_vault.vault.id
  key_type     = "RSA-HSM"
  key_size     = 2048
  expiration_date = "2030-12-30T20:00:00Z"

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
}

output "key_vault_name" {
  value = azurerm_key_vault.vault.name
}

############################
 # VAULT VM NEEDED RESOURCES
############################
resource "azurerm_virtual_network" "tf_network" {
  name                = "network-${random_id.keyvault.hex}"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.vault.name
}

resource "azurerm_subnet" "tf_subnet" {
  name                 = "subnet-${random_id.keyvault.hex}"
  resource_group_name  = azurerm_resource_group.vault.name
  virtual_network_name = azurerm_virtual_network.tf_network.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "tf_publicip" {
  name                = "ip-${random_id.keyvault.hex}"
  location            = var.location
  resource_group_name = azurerm_resource_group.vault.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_security_group" "tf_nsg" {
  name                = "nsg-${random_id.keyvault.hex}"
  location            = var.location
  resource_group_name = azurerm_resource_group.vault.name

  # security_rule {
  #   name                       = "SSH"
  #   priority                   = 1001
  #   direction                  = "Inbound"
  #   access                     = "Allow"
  #   protocol                   = "Tcp"
  #   source_port_range          = "*"
  #   destination_port_range     = "22"
  #   source_address_prefix      = "*"
  #   destination_address_prefix = "*"
  # }

  security_rule {
    name                       = "Vault"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8200"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Consul"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8500"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "tf_nic" {
  name                      = "nic-${random_id.keyvault.hex}"
  location                  = var.location
  resource_group_name       = azurerm_resource_group.vault.name

  ip_configuration {
    name                          = "nic-${random_id.keyvault.hex}"
    subnet_id                     = azurerm_subnet.tf_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.tf_publicip.id
  }
}

resource "azurerm_network_interface_security_group_association" "tf_nisga" {
  network_interface_id      = azurerm_network_interface.tf_nic.id
  network_security_group_id = azurerm_network_security_group.tf_nsg.id
}

resource "random_id" "tf_random_id" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.vault.name
  }

  byte_length = 8
}

############################
 # STORAGE ACCOUNT AND FILE SHARE
############################

resource "azurerm_storage_account" "tf_storageaccount" {
  name                     = "sa${random_id.keyvault.hex}"
  resource_group_name      = azurerm_resource_group.vault.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  public_network_access_enabled = false

  network_rules {
    default_action = "Deny"
    bypass = "AzureServices"
    ip_rules = "0.0.0.0/0"
  }
}

resource "azurerm_storage_share" "vault" {
  name                 = "vault-data"
  storage_account_name = azurerm_storage_account.tf_storageaccount.name
  quota                = 5
  depends_on = [
    azurerm_storage_account.tf_storageaccount
  ]
}

############################
 # FILE SHARE DIRECTORY
############################

resource "azurerm_storage_share_directory" "vault" {
  name                 = "certs"
  share_name           = azurerm_storage_share.vault.name
  storage_account_name = azurerm_storage_account.tf_storageaccount.name
  depends_on = [
    azurerm_storage_share.vault
  ]
}

############################
 # VM TEMPLATE FILE
############################

data "template_file" "setup" {
  template = file("${path.module}/setup.tpl")

  vars = {
    resource_group_name = "vault-vm-rg"
    vm_name             = var.vm_name
    vault_version       = var.vault_version
    tenant_id           = var.tenant_id
    subscription_id     = var.subscription_id
    client_id           = var.client_id
    client_secret       = var.client_secret
    vault_name          = azurerm_key_vault.vault.name
    key_name            = var.key_name
  }
}

############################
 # STORAGE ACCOUNT UAI
############################

# resource "azurerm_user_assigned_identity" "storage-uai" {
#   name                = "storage-uai"
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   depends_on = [
#     azurerm_resource_group.vault
#   ]
# }

# resource "azurerm_role_assignment" "storage-uai-assignment" {
#   role_definition_name  = "Contributor"
#   scope               = azurerm_storage_account.tf_storageaccount.id
#   principal_id        = azurerm_user_assigned_identity.storage-uai.principal_id
#   depends_on = [
#     azurerm_user_assigned_identity.storage-uai
#   ]
# }

############################
 # VM EXTENSION TO AUTOMATICALLY MOUNT FILESHARE
############################

resource "azurerm_virtual_machine_extension" "vm-extension" {
  name                 = "mountfileshare"
  virtual_machine_id   = azurerm_linux_virtual_machine.tf_vm.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
      "commandToExecute": "sudo apt-get -y install cifs-utils && sudo mkdir -p /mnt/vault-data && echo '//${azurerm_storage_account.tf_storageaccount.name}.file.core.windows.net/${azurerm_storage_share.vault.name} /mnt/vault-data cifs nofail,vers=3.0,username=${azurerm_storage_account.tf_storageaccount.name},password=${azurerm_storage_account.tf_storageaccount.primary_access_key},dir_mode=0777,file_mode=0777,serverino' | sudo tee -a /etc/fstab && sudo mount -a; touch /test.txt"
    }
  SETTINGS

  depends_on = [
    azurerm_storage_share.vault,
    azurerm_linux_virtual_machine.tf_vm
  ]
}



############################
 # VAULT VM CREATION
############################


# Create virtual machine
resource "azurerm_linux_virtual_machine" "tf_vm" {
  name                  = var.vm_name
  location              = var.location
  resource_group_name   = azurerm_resource_group.vault.name
  network_interface_ids = [azurerm_network_interface.tf_nic.id]
  size                  = "standard_a2_v2"
  custom_data           = base64encode(data.template_file.setup.rendered)
  computer_name         = var.vm_name
  admin_username        = "azureuser"

  admin_ssh_key {
    username   = "azureuser"
    public_key = var.public_key
  }

  # NB this identity is used in the example /tmp/azure_auth.sh file.
  #    vault is actually using the vault service principal.
  # identity {
  #   type                    = "UserAssigned"
  #   identity_ids            = [azurerm_user_assigned_identity.storage-uai.id]
  # }

  os_disk {
    name                 = "${var.vm_name}-os"
    caching              = "ReadWrite" # TODO is this safe?
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.tf_storageaccount.primary_blob_endpoint
  }
}

data "azurerm_public_ip" "tf_publicip" {
  name                = azurerm_public_ip.tf_publicip.name
  resource_group_name = azurerm_linux_virtual_machine.tf_vm.resource_group_name
}

output "ip" {
  value = data.azurerm_public_ip.tf_publicip.ip_address
}

output "ssh-addr" {
  value = <<SSH

    Connect to your virtual machine via SSH:

    $ ssh azureuser@${data.azurerm_public_ip.tf_publicip.ip_address}


SSH
}
