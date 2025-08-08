resource "azurerm_bastion_host" "bastion" {
  name                = "${random_pet.prefix.id}-bastion"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.my_terraform_subnet_1.id
    public_ip_address_id = azurerm_public_ip.public_ip.id
  }
}

# Public IP Address
resource "azurerm_public_ip" "public_ip" {
  name                = "${random_pet.prefix.id}-public-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}