data "azurerm_subscription" "primary" {}


resource "azurerm_dashboard_grafana" "grafana-dashboard" {
  name                              = var.grafana-dashboard.name
  resource_group_name               = var.observability_rg.name
  location                          = var.grafana-dashboard.location

  auto_generated_domain_name_label_scope = "TenantReuse"
  public_network_access_enabled = true
  api_key_enabled = false
  deterministic_outbound_ip_enabled = false
  zone_redundancy_enabled = false

  sku = "Standard"

  identity {
    type = "SystemAssigned"
  }

  depends_on = [azurerm_resource_group.observability_rg]
}


// Works, evaluate how to remove hardcoded principal id (probably the commented line is enough)
resource "azurerm_role_assignment" "grafana-reader-role-assignment" {
  #name = "monitoring-reader-role-assignment"
  scope = data.azurerm_subscription.primary.id
  principal_id = azurerm_dashboard_grafana.grafana-dashboard.identity[0].principal_id
  #principal_id = "84edb984-ec6d-46ab-b236-83d3185ee2ad"
  role_definition_name = "Monitoring Reader"
} 


data "azuread_user" "ad_user" {
  #user_principal_name = "s297014@studenti.polito.it"
  user_principal_name = "ma.colotti_reply.it#EXT#@francescoborgognihotmailit.onmicrosoft.com"
}

// "Grafana Admin" role should work, principal Id should be my own account
resource "azurerm_role_assignment" "grafana-admin-role-assignment" {
 # name = "monitoring-admin-role-assignment"
  scope = azurerm_dashboard_grafana.grafana-dashboard.id
  principal_id = data.azuread_user.ad_user.id
  role_definition_name = "Grafana Admin"
}