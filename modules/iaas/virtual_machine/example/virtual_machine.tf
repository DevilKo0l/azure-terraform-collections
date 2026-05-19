locals {
  vm_configs = try(local.workload_config.compute.vms, {})
}

module "virtual_machines" {
  for_each = local.vm_configs

  source = "../../../modules/compute/virtual_machine"

   name = "vm-${local.resource_suffix}-${try(each.value.role, each.key)}-${lower(try(each.value.os_type, "linux"))}"

  location            = var.location
  resource_group_name = module.resource_group.name

  subnet_id = module.vnet.subnet_ids[each.value.subnet_name]

  os_type = try(
    each.value.os_type,
    "linux"
  )

  vm_size = try(
    each.value.vm_size,
    "Standard_B2s"
  )

  admin_username = try(
    each.value.admin_username,
    "azureuser"
  )

  admin_password = try(
    each.value.admin_password,
    null
  )

  disable_password_authentication = try(
    each.value.disable_password_authentication,
    true
  )

  admin_ssh_public_key = try(
    each.value.admin_ssh_public_key,
    null
  )

  create_public_ip = try(
    each.value.create_public_ip,
    false
  )

  private_ip_address_allocation = try(
    each.value.private_ip_address_allocation,
    "Dynamic"
  )

  private_ip_address = try(
    each.value.private_ip_address,
    null
  )

  os_disk_storage_account_type = try(
    each.value.os_disk_storage_account_type,
    "Standard_LRS"
  )

  os_disk_size_gb = try(
    each.value.os_disk_size_gb,
    64
  )

  source_image_reference = try(
    each.value.source_image_reference,
    each.value.os_type == "windows" ? {
      publisher = "MicrosoftWindowsServer"
      offer     = "WindowsServer"
      sku       = "2022-datacenter-azure-edition"
      version   = "latest"
    } : {
      publisher = "Canonical"
      offer     = "0001-com-ubuntu-server-jammy"
      sku       = "22_04-lts"
      version   = "latest"
    }
  )

  identity_type = try(
    each.value.identity_type,
    "SystemAssigned"
  )

  user_assigned_identity_ids = try(
    each.value.user_assigned_identity_ids,
    []
  )

  tags = local.common_tags
}