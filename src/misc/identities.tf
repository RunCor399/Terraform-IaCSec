# resource "azurerm_user_assigned_identity" "custodian_uai" {
#   location            = var.simple_resource_group.location
#   name                = "custodian-uai"
#   resource_group_name = "cloud-custodian"
# }

# data "azurerm_subscription" "primary" {
# }

# resource "azurerm_role_assignment" "custodian_uai_assignment" {
#   scope                = data.azurerm_subscription.primary.id
#   role_definition_name = "Contributor"
#   principal_id         = azurerm_user_assigned_identity.custodian_uai.principal_id
# }