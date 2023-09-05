
resource "azurerm_log_analytics_workspace" "log_analytics_workspace" {
    name = var.log-analytics-workspace.name
    location = var.log-analytics-workspace.location
    resource_group_name = var.observability_rg.name
    sku = "PerGB2018"

    depends_on = [azurerm_resource_group.observability_rg]
}