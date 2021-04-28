terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }

  required_version = ">= 0.14.9"
}

provider "azurerm" {
  skip_provider_registration = true
  features {}
}

resource "azurerm_resource_group" "resourcegroup" {
  name     = "ResourceGroupTerraform"
  location = "westus2"
}

resource "azurerm_virtual_network" "virtualnetwork" {
  name                = "VirtualNetworkTerraform"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.resourcegroup.location
  resource_group_name = azurerm_resource_group.resourcegroup.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "SubnetTerraform"
  resource_group_name  = azurerm_resource_group.resourcegroup.name
  virtual_network_name = azurerm_virtual_network.virtualnetwork.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "networkinterface" {
  name                = "NetworkInterfaceTerraform"
  location            = azurerm_resource_group.resourcegroup.location
  resource_group_name = azurerm_resource_group.resourcegroup.name

  ip_configuration {
    name                          = "IpConfigurationTerraform"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.publicip.id
  }
}

resource "azurerm_network_interface_security_group_association" "networkinterfacesecuritygroupassociation" {
  network_interface_id      = azurerm_network_interface.networkinterface.id
  network_security_group_id = azurerm_network_security_group.networksecuritygroup.id
}

resource "azurerm_virtual_machine" "virtualmachine" {
  name                  = "UbuntuVirtualMachineTerraform"
  location              = azurerm_resource_group.resourcegroup.location
  resource_group_name   = azurerm_resource_group.resourcegroup.name
  network_interface_ids = [azurerm_network_interface.networkinterface.id]
  vm_size               = "Standard_DS1_v2"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "StorageOSDiskTerraform"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "OSProfilerTerraform"
    admin_username = "adminterraform"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    environment = "terraform"
  }
}

resource "azurerm_network_security_group" "networksecuritygroup" {
  name                = "NetworkSecurityGroupTerraform"
  location            = azurerm_resource_group.resourcegroup.location
  resource_group_name = azurerm_resource_group.resourcegroup.name

  security_rule {
    name                       = "RulePortSSHTerraform"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  
}

resource "azurerm_public_ip" "publicip" {
  name                = "PublicIpTerraform"
  resource_group_name = azurerm_resource_group.resourcegroup.name
  location            = azurerm_resource_group.resourcegroup.location
  allocation_method   = "Static"
}
