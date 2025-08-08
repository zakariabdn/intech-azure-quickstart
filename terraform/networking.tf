# Network Interface connects VM to subnet
resource "azurerm_network_interface" "nic1" {
  name                = "${random_pet.prefix.id}-nic1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.my_terraform_subnet_2.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Network Interface connects VM to subnet
resource "azurerm_network_interface" "nic2" {
  name                = "${random_pet.prefix.id}-nic2"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.my_terraform_subnet_2.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Allow Traffic to Bastion Host: Ensure that traffic can flow back to the Bastion host (if needed).
# Allow Traffic to Virtual Network: Allow traffic to other resources within the same virtual network.
# Restrict Internet Access: Disallow internet access or any other outbound traffic not related to Bastion or internal communications.
resource "azurerm_network_security_group" "private_nsg" {
  name                = "private-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "Allow-VNet-SSH-Inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-VNet-RDP-Inbound"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-VNet-Outbound"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "Deny-Internet-Outbound"
    priority                   = 200
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "0.0.0.0/0"
  }
}

# Associate NSG with Subnet 2
resource "azurerm_subnet_network_security_group_association" "subnet_2_nsg" {
  subnet_id                 = azurerm_subnet.my_terraform_subnet_2.id
  network_security_group_id = azurerm_network_security_group.private_nsg.id
}