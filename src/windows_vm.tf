# resource "azurerm_virtual_network" "simple_virtual_network" {
#   name                = var.virtual_networks.vm_vn.name
#   address_space       = var.virtual_networks.vm_vn.address_space
#   location            = var.simple_resource_group.location
#   resource_group_name = var.simple_resource_group.name
#   depends_on = [
#     azurerm_resource_group.simple_resource_group
#   ]
# }



# resource "azurerm_subnet" "simple_subnet" {
#   name                 = "internal"
#   resource_group_name  = var.simple_resource_group.name
#   virtual_network_name = azurerm_virtual_network.simple_virtual_network.name
#   address_prefixes     = ["10.1.2.0/24"]
#   depends_on = [
#     azurerm_resource_group.simple_resource_group,
#     azurerm_virtual_network.simple_virtual_network
#   ]
# }

# resource "azurerm_network_interface" "simple_network_interface" {
#   name                = "simple-nic"
#   location            = var.simple_resource_group.location
#   resource_group_name = var.simple_resource_group.name


#   ip_configuration {
#     name                          = "internal"
#     subnet_id                     = azurerm_subnet.simple_subnet.id
#     private_ip_address_allocation = "Dynamic"
#     #public_ip_address_id          = azurerm_public_ip.simple-public-ip.id
#   }

#   depends_on = [
#     azurerm_resource_group.simple_resource_group,
#     azurerm_subnet.simple_subnet,
#     #azurerm_public_ip.simple-public-ip
#   ]
# }


# resource "azurerm_windows_virtual_machine" "simple_vm" {
#   name                = "simple-vm-2"
#   resource_group_name = var.simple_resource_group.name
#   location            = var.simple_resource_group.location
#   size                = "Standard_B1s"
#   admin_username      = "adminuser"
#   admin_password      = "Fakep4ssword"
#   network_interface_ids = [
#     azurerm_network_interface.simple_network_interface.id,
#   ]
  

#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }

#   source_image_reference {
#     publisher = "MicrosoftWindowsServer"
#     offer     = "WindowsServer"
#     sku       = "2016-Datacenter"
#     version   = "latest"
#   }

#   depends_on = [
#     azurerm_resource_group.simple_resource_group,
#     azurerm_network_interface.simple_network_interface
#   ]
# }



# # resource "azurerm_public_ip" "simple-public-ip" {
# #   name                = "simple-public-ip"
# #   resource_group_name = azurerm_resource_group.simple_resource_group.name
# #   location            = azurerm_resource_group.simple_resource_group.location
# #   allocation_method   = "Static"
# # }
