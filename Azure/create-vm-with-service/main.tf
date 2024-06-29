# Load the services definition for the VM
data "template_file" "vm_config" {
  template = file("${path.module}/config.tmpl.yml")

  vars = {
    env = var.env
  }
}

resource "null_resource" "vm_config_update" {
  depends_on = [azurerm_virtual_machine.main]

  triggers = {
    template_rendered = data.template_file.vm_config.rendered
  }

  connection {
    type        = "ssh"
    user        = "azureadmin"
    host        = azurerm_public_ip.my_terraform_public_ip.ip_address
    private_key = file("~/.ssh/id_rsa")
  }

  provisioner "file" {
    content     = data.template_file.vm_config.rendered
    destination = "/tmp/ConfigData"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo diff /tmp/ConfigData /var/lib/waagent/ConfigData | tee /tmp/ConfigData-diff",
      "sudo cp /tmp/ConfigData /var/lib/waagent/ConfigData"
    ]
  }
}

resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = "${random_pet.prefix.id}-rg"
}

# Create virtual network
resource "azurerm_virtual_network" "my_terraform_network" {
  name                = "${random_pet.prefix.id}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Create subnet
resource "azurerm_subnet" "my_terraform_subnet" {
  name                 = "${random_pet.prefix.id}-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.my_terraform_network.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create public IPs
resource "azurerm_public_ip" "my_terraform_public_ip" {
  name                = "${random_pet.prefix.id}-public-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

# Create Network Security Group and rules
resource "azurerm_network_security_group" "my_terraform_nsg" {
  name                = "${random_pet.prefix.id}-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  # for SSH access to the VM
  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Create network interface
resource "azurerm_network_interface" "my_terraform_nic" {
  name                = "${random_pet.prefix.id}-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "my_nic_configuration"
    subnet_id                     = azurerm_subnet.my_terraform_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.my_terraform_public_ip.id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.my_terraform_nic.id
  network_security_group_id = azurerm_network_security_group.my_terraform_nsg.id
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "my_storage_account" {
  name                     = "diag${random_id.random_id.hex}"
  location                 = azurerm_resource_group.rg.location
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Create virtual machine

resource "azurerm_virtual_machine" "main" {
  name                  = "${var.prefix}-vm"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.my_terraform_nic.id]
  vm_size               = "Standard_DS1_v2"

  # https://azuremarketplace.microsoft.com/en-gb/marketplace/apps/kinvolk.flatcar-container-linux-free?tab=Overview
  # az vm image list --all --publisher kinvolk | grep flatcar
  storage_image_reference {
    publisher = "kinvolk"
    offer     = "flatcar-container-linux-free"
    sku       = "stable"
    version   = "3815.2.3"
  }
  storage_os_disk {
    name              = "${var.rg_prefix}-osdisk"
    managed_disk_type = "Standard_LRS"
    caching           = "ReadWrite"
    create_option     = "FromImage"
  }
  delete_os_disk_on_termination = true

  # NOTE: Add if any
  # storage_data_disk {
  # }

  os_profile {
    computer_name  = "${var.prefix}-vm"
    admin_username = var.admin_username

    custom_data = <<-EOF
      ${file("./config.tmpl.yml")}
      EOF
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/${var.admin_username}/.ssh/authorized_keys"
      key_data = var.admin_ssh_key
    }
  }

  tags = {
    env = "${var.env}"
  }
  boot_diagnostics {
    enabled     = true
    storage_uri = azurerm_storage_account.my_storage_account.primary_blob_endpoint
  }
}


# Generate random text for a unique storage account name
resource "random_id" "random_id" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.rg.name
  }

  byte_length = 8
}

resource "random_password" "password" {
  length      = 20
  min_lower   = 1
  min_upper   = 1
  min_numeric = 1
  min_special = 1
  special     = true
}

resource "random_pet" "prefix" {
  prefix = var.prefix
  length = 1
}
