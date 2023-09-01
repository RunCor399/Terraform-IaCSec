
# resource "azurerm_storage_account" "custodian_storage_account" {
#   name                     = "custodianstoragemec"
#   resource_group_name      = "cloud-custodian"
#   location                 = var.simple_resource_group.location
#   account_tier             = "Standard"
#   account_replication_type = "LRS"
# }

# resource "azurerm_service_plan" "functionshost" {
#   name                = "functionshost"
#   resource_group_name = "cloud-custodian"
#   location            = var.simple_resource_group.location
#   os_type             = "Linux"
#   sku_name            = "Y1"

# }

# resource "azurerm_user_assigned_identity" "example" {
#   location            = azurerm_resource_group.example.location
#   name                = "example"
#   resource_group_name = azurerm_resource_group.example.name
# }

