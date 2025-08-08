# Define LB
resource "azurerm_lb" "lb" {
  name                = "example-lb"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                          = "example-fe"
    subnet_id                     = azurerm_subnet.my_terraform_subnet_2.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Hold private IP addresses of VMs
resource "azurerm_lb_backend_address_pool" "bap" {
  name            = "example-bap"
  loadbalancer_id = azurerm_lb.lb.id
}

# The probe ID ensures the LB only routes traffic to healthy VM
resource "azurerm_lb_probe" "probe" {
  name                = "example-probe"
  loadbalancer_id     = azurerm_lb.lb.id
  protocol            = "Tcp"
  port                = 80
  interval_in_seconds = 5
  number_of_probes    = 2
}

# The rule directs incoming traffic on port 80 of the LB to port 80 of the VMs in the BAP - TCP (HTTP)
resource "azurerm_lb_rule" "rule" {
  name                           = "example-rule"
  loadbalancer_id                = azurerm_lb.lb.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = azurerm_lb.lb.frontend_ip_configuration[0].name
  probe_id                       = azurerm_lb_probe.probe.id
}

# These associations add the VMs' private IP addresses to the BAP, effectively adding them to the load-balanced pool
resource "azurerm_network_interface_backend_address_pool_association" "association_vm1" {
  network_interface_id    = azurerm_network_interface.nic1.id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.bap.id
}

resource "azurerm_network_interface_backend_address_pool_association" "association_vm2" {
  network_interface_id    = azurerm_network_interface.nic2.id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.bap.id
}