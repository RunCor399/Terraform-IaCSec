
resource "azurerm_virtual_network" "database_virtual_network" {
  name                = "database_virtual_network"
  location            = var.mysql_db_resource_group.location
  resource_group_name = var.mysql_db_resource_group.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "database_vn_subnet" {
  name                 = "database_vn_subnet"
  resource_group_name  = var.mysql_db_resource_group.name
  virtual_network_name = var.mysql_db_resource_group.location
  address_prefixes     = ["10.0.2.0/24"]
  service_endpoints    = ["Microsoft.Storage"]
  delegation {
    name = "fs"
    service_delegation {
      name = "Microsoft.DBforMySQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

resource "azurerm_network_security_group" "db_network_nsg" {
  name                = "databaseNSG"
  location            = var.mysql_db_resource_group.location
  resource_group_name = var.mysql_db_resource_group.name

  security_rule {
    name                       = "InboundDBConnections"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3306"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "example" {
  subnet_id                 = azurerm_subnet.database_vn_subnet.id
  network_security_group_id = azurerm_network_security_group.db_network_nsg.id
}



resource "azurerm_private_dns_zone" "database_dns_zone" {
  name                = "databasemysqlmec.com"
  resource_group_name = var.mysql_db_resource_group.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_zone" {
  name                  = "exampleVnetZone.com"
  private_dns_zone_name = azurerm_private_dns_zone.database_dns_zone.name
  virtual_network_id    = azurerm_virtual_network.database_virtual_network.id
  resource_group_name   = var.mysql_db_resource_group.name
}

resource "azurerm_mysql_flexible_server" "mysql_flexible_server" {
  name                   = "databasemysqlmec"
  resource_group_name    = var.mysql_db_resource_group.name
  location               = var.mysql_db_resource_group.location
  administrator_login    = "runcor3"
  administrator_password = "testFakePassword."
  backup_retention_days  = 7
  delegated_subnet_id    = azurerm_subnet.database_vn_subnet.id
  private_dns_zone_id    = azurerm_private_dns_zone.database_dns_zone.id
  sku_name               = "B_Standard_B1s"
  version                = "8.0.21"
  depends_on = [azurerm_resource_group.mysql_db_resource_group,
                azurerm_private_dns_zone_virtual_network_link.private_dns_zone]
}
