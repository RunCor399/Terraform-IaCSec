
resource "azurerm_service_plan" "keycloak-sp" {
  name                = "keycloak-sp"
  resource_group_name = var.keycloak-resource-group.name
  location            = var.keycloak-resource-group.location
  os_type             = "Linux"
  sku_name            = "F1"

  depends_on = [ azurerm_resource_group.keycloak-resource-group ]
}

resource "azurerm_linux_web_app" "keycloak-webapp" {
  name                = "keycloak-webapp"
  resource_group_name = var.keycloak-resource-group.name
  location            = var.keycloak-resource-group.location
  service_plan_id     = azurerm_service_plan.keycloak-sp.id

  https_only = true

  app_settings = {
      "KEYCLOAK_ADMIN" = "admin"
      "KEYCLOAK_ADMIN_PASSWORD" = sensitive(var.secrets.admin_password)
      "DOCKER_REGISTRY_SERVER_URL" = "https://registry.hub.docker.com/v2/"
      "WEBSITE_ENABLE_APP_SERVICE_STORAGE" = true
  }

  site_config {
    always_on = false
  }

  depends_on = [ azurerm_service_plan.keycloak-sp ]

}

output "hostname" {
  value = azurerm_linux_web_app.keycloak-webapp.default_hostname
}

resource "azapi_update_resource" "update_linux_web_app" {
  resource_id = azurerm_linux_web_app.keycloak-webapp.id
  type        = "Microsoft.Web/sites@2022-03-01"
  body = jsonencode({
    properties = {
      "siteConfig" = {
        "linuxFxVersion" = "COMPOSE|${base64encode(file("keycloak_service.yaml"))}"
      }
      "appSettings" = {
        "keycloakFrontendUrl" = join("/", [azurerm_linux_web_app.keycloak-webapp.default_hostname, "auth"])
      }
    }
  })

  depends_on = [ azurerm_linux_web_app.keycloak-webapp ]
}