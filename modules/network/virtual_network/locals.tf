locals {
  tags = merge(
    var.tags,
    {
      service   = "network"
      component = "vnet"
    }
  )
}