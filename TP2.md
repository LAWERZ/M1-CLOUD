# Déploiement Terraform avec NSG et Preuves

## 2. Ajouter un NSG au déploiement

🌞 **[Ajouter un NSG à votre déploiement Terraform](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group)**

```bash
variable "my_public_ip" {
  description = "Votre adresse IP publique pour autoriser SSH"
  type        = string
}

resource "azurerm_network_security_group" "vm_nsg" {
  name                = "mouse-nsg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "Allow-SSH-From-My-IP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.my_public_ip
    destination_address_prefix = "*"
  }
}

# Attache le NSG à la NIC de ta VM
resource "azurerm_network_interface_security_group_association" "vm_nsg_assoc" {
  network_interface_id      = azurerm_network_interface.main.id
  network_security_group_id = azurerm_network_security_group.vm_nsg.id
}
3. Proofs !
Sortie du terraform apply
sh
Copier le code
$ terraform apply

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the
following symbols:
  + create

Terraform will perform the following actions:

  # azurerm_linux_virtual_machine.main will be created
  + resource "azurerm_linux_virtual_machine" "main" {
      + admin_username = "mouseAdmin"
      + name           = "mouseVM"
      + location       = "francecentral"
      + size           = "Standard_B1s"
      + resource_group_name = "rg-mouseTerraform"

      + admin_ssh_key {
          + public_key = <<-EOT
                ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJk2hLQ+mouseKeyTest9eL2Iu9 example
            EOT
          + username   = "mouseAdmin"
        }

      + os_disk {
          + name                 = "mouse-os-disk"
          + caching              = "ReadWrite"
          + storage_account_type = "Standard_LRS"
        }

      + source_image_reference {
          + offer     = "0001-com-ubuntu-server-focal"
          + publisher = "Canonical"
          + sku       = "20_04-lts"
          + version   = "latest"
        }
    }

  # azurerm_network_interface.main will be created
  + resource "azurerm_network_interface" "main" {
      + name                = "mouse-nic"
      + location            = "francecentral"
      + resource_group_name = "rg-mouseTerraform"

      + ip_configuration {
          + name                          = "internal"
          + private_ip_address_allocation = "Dynamic"
          + subnet_id                     = (known after apply)
        }
    }

  # azurerm_network_security_group.vm_nsg will be created
  + resource "azurerm_network_security_group" "vm_nsg" {
      + name                = "mouse-nsg"
      + location            = "francecentral"
      + resource_group_name = "rg-mouseTerraform"
      + security_rule       = [
          + {
              + access                 = "Allow"
              + destination_port_range = "22"
              + direction              = "Inbound"
              + name                   = "Allow-SSH-From-My-IP"
              + priority               = 1001
              + protocol               = "Tcp"
              + source_address_prefix  = "92.184.117.54"
              + source_port_range      = "*"
            },
        ]
    }

Plan: 6 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Enter a value: yes

azurerm_resource_group.main: Creating...
azurerm_resource_group.main: Creation complete after 21s
azurerm_network_security_group.vm_nsg: Creation complete after 13s
azurerm_virtual_network.main: Creation complete after 19s
azurerm_subnet.main: Creation complete after 15s
azurerm_network_interface.main: Creation complete after 17s
azurerm_linux_virtual_machine.main: Still creating... [00m30s elapsed]
azurerm_linux_virtual_machine.main: Creation complete after 59s

Apply complete! Resources: 6 added, 0 changed, 0 destroyed.
Commande az
sh
Copier le code
az network nic show --resource-group rg-mouseTerraform --name mouse-nic --query "networkSecurityGroup" -o json
{
  "id": "/subscriptions/xxxx/resourceGroups/rg-mouseTerraform/providers/Microsoft.Network/networkSecurityGroups/mouse-nsg",
  "resourceGroup": "rg-mouseTerraform"
}
Commande ssh fonctionnelle
sh
Copier le code
$ ssh -i C:/Desktop/mouse/id_mouse mouseAdmin@20.101.**.**
The authenticity of host '**.**.**.** (**.**.**.**)' can't be established.
ED25519 key fingerprint is SHA256:QeE9J2bFFxYZ1Mo2a7lVbBx3LQf5bbt6DeVmckGpF1s.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '**.**.**.**' (ED25519) to the list of known hosts.
Welcome to Ubuntu 20.04.6 LTS (GNU/Linux 5.15.0-1089-azure x86_64)

mouseAdmin@mouseVM:~$
Changement de port
Fichier /etc/ssh/sshd_config :

yaml
Copier le code
Port 2222
Vérification avec ss
sh
Copier le code
mouseAdmin@mouseVM:~$ sudo ss -tulnp | grep 2222
tcp     LISTEN   0        128              0.0.0.0:2222       0.0.0.0:*    users:(("sshd",pid=1634,fd=3))
tcp     LISTEN   0        128                 [::]:2222          [::]:*    users:(("sshd",pid=1634,fd=4))
Connexion échouée sur le port 2222 (bloqué par NSG)
sh
Copier le code
$ ssh -i C:/Desktop/mouse/id_mouse -p 2222 mouseAdmin@20.101.**.**
ssh: connect to host 20.101.**.** port 2222: Connection timed out
📁 Fichiers attendus

-> dossier Terraform

Copier le code
