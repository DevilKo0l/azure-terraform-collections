locals {
  os_type = lower(var.os_type)

  create_linux_vm   = local.os_type == "linux"
  create_windows_vm = local.os_type == "windows"

  nic_name       = "nic-${var.name}"
  os_disk_name   = "osdisk-${var.name}"
  public_ip_name = "pip-${var.name}"

  identity_enabled = var.identity_type != "None"

  tags = merge(
    var.tags,
    {
      component = "virtual_machine"
    }
  )
}