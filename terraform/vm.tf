resource "azurerm_availability_set" "avset" {
  name                         = "example-avset"
  location                     = azurerm_resource_group.rg.location
  resource_group_name          = azurerm_resource_group.rg.name
  platform_fault_domain_count  = 2
  platform_update_domain_count = 5
  managed                      = true
}

# Linux Virtual Machine
resource "azurerm_linux_virtual_machine" "vm1" {
  name                = "${random_pet.prefix.id}-vm1"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B1s"
  admin_username      = "azureuser"
  network_interface_ids = [
    azurerm_network_interface.nic1.id,
  ]

  availability_set_id = azurerm_availability_set.avset.id

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("${var.public_key_loc}")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-LTS"
    version   = "latest"
  }
}

# Linux Virtual Machine
resource "azurerm_linux_virtual_machine" "vm2" {
  name                = "${random_pet.prefix.id}-vm2"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B1s"
  admin_username      = "azureuser"
  network_interface_ids = [
    azurerm_network_interface.nic2.id,
  ]

  availability_set_id = azurerm_availability_set.avset.id

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("${var.public_key_loc}")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-LTS"
    version   = "latest"
  }
}