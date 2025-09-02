variable "resource_name" {
  default = "om"
}
variable "location" {
  default = "noe"
}
variable "version" {
  default = "1"
}

# Define resource group
resource "azurerm_resource_group" "main" {
  name     = "rg-${var.resource_name}-${var.location}-${var.version}"
  location = "Norway East"
}

# Define virtual network
resource "azurerm_virtual_network" "main" {
  name                = "vnet-${var.resource_name}-${var.location}-${var.version}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

# Define network interface
resource "azurerm_network_interface" "main" {
  name                = "nic-${var.resource_name}-${var.location}-${var.version}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

# Define vm
resource "azurerm_virtual_machine" "main" {
  name                  = "vml-${var.resource_name}-${var.location}-${var.version}"
  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_A8_v2"

  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-noble"
    sku       = "24_04-lts"
    version   = "latest"
  }
  storage_os_disk {
    name              = "omosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "omhost"
    admin_username = "omadmin"
    admin_password = "omadmon"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}

# Define autoshutdown
resource "azurerm_dev_test_global_vm_shutdown_schedule" "main" {
  virtual_machine_id = azurerm_virtual_machine.main.id
  location           = azurerm_resource_group.main.location
  enabled            = true

  daily_recurrence_time = "1800"
  timezone              = "W. Europe Standard Time"

  notification_settings {
    enabled = false
  }
}

# Install Elasticsearch
resource "azurerm_virtual_machine_run_command" "main" {
  name               = "install-elasticsearch-vmrc"
  location           = azurerm_resource_group.main.location
  virtual_machine_id = azurerm_virtual_machine.main.id
  source {
    script = "echo 'hello world'"
  }
}

# Install Openmetadata
resource "azurerm_virtual_machine_run_command" "main" {
  name               = "install-openmetadata-vmrc"
  location           = azurerm_resource_group.main.location
  virtual_machine_id = azurerm_virtual_machine.main.id
  source {
    script = "echo 'hello world'"
  }
}

# Install Airflow
resource "azurerm_virtual_machine_run_command" "main" {
  name               = "install-airflow-vmrc"
  location           = azurerm_resource_group.main.location
  virtual_machine_id = azurerm_virtual_machine.main.id
  source {
    script = "echo 'hello world'"
  }
}