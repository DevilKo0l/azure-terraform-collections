variable "name" {
  description = "Name of the virtual machine."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name."
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where the VM network interface will be attached."
  type        = string
}

variable "os_type" {
  description = "Operating system type. Allowed values: linux, windows."
  type        = string
  default     = "linux"

  validation {
    condition     = contains(["linux", "windows"], lower(var.os_type))
    error_message = "os_type must be either 'linux' or 'windows'."
  }
}

variable "vm_size" {
  description = "Azure VM size/tier."
  type        = string
  default     = "Standard_B2s"
}

variable "admin_username" {
  description = "Admin username."
  type        = string
  default     = "azureuser"
}

variable "admin_password" {
  description = "Admin password. Required for Windows VM or Linux password authentication."
  type        = string
  default     = null
  sensitive   = true
}

variable "disable_password_authentication" {
  description = "Disable password authentication for Linux VM."
  type        = bool
  default     = true
}

variable "admin_ssh_public_key" {
  description = "SSH public key for Linux VM."
  type        = string
  default     = null
}

variable "private_ip_address_allocation" {
  description = "Private IP allocation method."
  type        = string
  default     = "Dynamic"

  validation {
    condition     = contains(["Dynamic", "Static"], var.private_ip_address_allocation)
    error_message = "private_ip_address_allocation must be Dynamic or Static."
  }
}

variable "private_ip_address" {
  description = "Static private IP address. Only needed when private_ip_address_allocation is Static."
  type        = string
  default     = null
}

variable "create_public_ip" {
  description = "Create a public IP for the VM."
  type        = bool
  default     = false
}

variable "public_ip_sku" {
  description = "Public IP SKU."
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(["Basic", "Standard"], var.public_ip_sku)
    error_message = "public_ip_sku must be Basic or Standard."
  }
}

variable "public_ip_allocation_method" {
  description = "Public IP allocation method."
  type        = string
  default     = "Static"

  validation {
    condition     = contains(["Dynamic", "Static"], var.public_ip_allocation_method)
    error_message = "public_ip_allocation_method must be Dynamic or Static."
  }
}

variable "os_disk_caching" {
  description = "OS disk caching."
  type        = string
  default     = "ReadWrite"
}

variable "os_disk_storage_account_type" {
  description = "OS disk storage type."
  type        = string
  default     = "Standard_LRS"

  validation {
    condition = contains([
      "Standard_LRS",
      "StandardSSD_LRS",
      "Premium_LRS",
      "StandardSSD_ZRS",
      "Premium_ZRS"
    ], var.os_disk_storage_account_type)

    error_message = "Invalid OS disk storage account type."
  }
}

variable "os_disk_size_gb" {
  description = "OS disk size in GB."
  type        = number
  default     = 64
}

variable "source_image_reference" {
  description = "VM source image reference."
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
  description = "Managed identity type. Allowed values: SystemAssigned, UserAssigned, SystemAssigned, UserAssigned, None."
  type        = string
  default     = "SystemAssigned"

  validation {
    condition = contains([
      "SystemAssigned",
      "UserAssigned",
      "SystemAssigned, UserAssigned",
      "None"
    ], var.identity_type)

    error_message = "identity_type must be SystemAssigned, UserAssigned, SystemAssigned, UserAssigned, or None."
  }
}

variable "user_assigned_identity_ids" {
  description = "User-assigned managed identity IDs."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags."
  type        = map(string)
  default     = {}
}