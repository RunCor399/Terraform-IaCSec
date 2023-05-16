
# resource "azurerm_virtual_network" "aks_virtual_network" {
#   name                = "aks-vnet"
#   location            = azurerm_resource_group.aks_resource_group.location
#   resource_group_name = azurerm_resource_group.aks_resource_group.name
#   address_space       = ["10.10.0.0/16"]
# }

# resource "azurerm_subnet" "aks_node_subnet" {
#   name                 = "aks-node-subnet"
#   virtual_network_name = azurerm_virtual_network.aks_virtual_network.name
#   resource_group_name  = azurerm_resource_group.aks_resource_group.name
#   address_prefixes     = ["10.10.1.0/24"]
# depends_on = [
#     azurerm_resource_group.aks_resource_group,
#     azurerm_virtual_network.aks_virtual_network
# ]
# }




# resource "azurerm_kubernetes_cluster" "aks_cluster" {
#   name                = "aks-cluster"
#   location            = azurerm_resource_group.aks_resource_group.location
#   resource_group_name = azurerm_resource_group.aks_resource_group.name
#   dns_prefix          = "aks-cluster"

#   default_node_pool {
#     name           = "default"
#     node_count     = 2
#     vm_size        = "Standard_B2s"
#     vnet_subnet_id = azurerm_subnet.aks_node_subnet.id
#   }


#   identity {
#     type = "SystemAssigned"
#   }


#   azure_policy_enabled             = true
#   http_application_routing_enabled = false
# }