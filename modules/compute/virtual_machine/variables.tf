variable "name" {
  description = "Name of the virtual machine."
  type        = string

  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 64
    error_message = "Virtual machine name must be between 1 and 64 characters."
  }
}

variable "location" {
  description = "Azure region where the virtual machine will be created."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group where the virtual machine will be created."
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where the virtual machine network interface will be attached."
  type        = string
}

variable "os_type" {
  description = "Virtual machine operating system type. Supported values: linux, windows."
  type        = string
  default     = "linux"

  validation {
    condition     = contains(["linux", "windows"], lower(var.os_type))
    error_message = "os_type must be either 'linux' or 'windows'."
  }
}

variable "size" {
  description = "Azure virtual machine size."
  type        = string
  default     = "Standard_B2s"
}

variable "admin_username" {
  description = "Administrator username for the virtual machine."
  type        = string
  default     = "azureuser"
}

variable "admin_password" {
  description = "Administrator password for Windows VMs or Linux password authentication when enabled."
  type        = string
  default     = null
  sensitive   = true
}

variable "disable_password_authentication" {
  description = "Disable password authentication for Linux VMs."
  type        = bool
  default     = true
}

variable "admin_ssh_public_key" {
  description = "SSH public key for Linux VM authentication. Required when disable_password_authentication is true."
  type        = string
  default     = null
}

variable "private_ip_address_allocation" {
  description = "Private IP allocation method for the VM network interface."
  type        = string
  default     = "Dynamic"

  validation {
    condition     = contains(["Dynamic", "Static"], var.private_ip_address_allocation)
    error_message = "private_ip_address_allocation must be either Dynamic or Static."
  }
}

variable "private_ip_address" {
  description = "Static private IP address. Required when private_ip_address_allocation is Static."
  type        = string
  default     = null
}

variable "create_public_ip" {
  description = "Whether to create and attach a public IP address."
  type        = bool
  default     = false
}

variable "public_ip_sku" {
  description = "SKU for the public IP address."
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(["Basic", "Standard"], var.public_ip_sku)
    error_message = "public_ip_sku must be Basic or Standard."
  }
}

variable "public_ip_allocation_method" {
  description = "Allocation method for the public IP address."
  type        = string
  default     = "Static"

  validation {
    condition     = contains(["Dynamic", "Static"], var.public_ip_allocation_method)
    error_message = "public_ip_allocation_method must be Dynamic or Static."
  }
}

variable "os_disk_caching" {
  description = "Caching type for the OS disk."
  type        = string
  default     = "ReadWrite"
}

variable "os_disk_storage_account_type" {
  description = "Storage account type for the OS disk."
  type        = string
  default     = "Standard_LRS"
}

variable "source_image_reference" {
  description = "Source image reference used to create the virtual machine."
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  default = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

variable "identity_type" {
  description = "Managed identity type. Supported values: SystemAssigned, UserAssigned, SystemAssigned, UserAssigned, or None."
  type        = string
  default     = "SystemAssigned"

  validation {
    condition     = contains(["SystemAssigned", "UserAssigned", "SystemAssigned, UserAssigned", "None"], var.identity_type)
    error_message = "identity_type must be SystemAssigned, UserAssigned, SystemAssigned, UserAssigned, or None."
  }
}

variable "user_assigned_identity_ids" {
  description = "User-assigned managed identity IDs. Required when identity_type includes UserAssigned."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply to all resources."
  type        = map(string)
  default     = {}
}