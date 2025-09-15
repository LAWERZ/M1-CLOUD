variable "subscription_id" {
  type = string
}

variable "resource_group_name" {
  type    = string
  default = "meo"
}

variable "location" {
  type    = string
  default = "francecentral"
}

variable "vm_name" {
  type    = string
  default = "vm-terra"
}

variable "admin_username" {
  type    = string
  default = "mouse"
}

variable "ssh_public_key_path" {
  type    = string
  default = "C:\\Users\\mouse\\.ssh\\cloud_tp1.pub"
}

variable "vm_size" {
  type    = string
  default = "Standard_B1s"
}

