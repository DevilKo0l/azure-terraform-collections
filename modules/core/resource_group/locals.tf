locals {  
  tags = merge(
    var.tags,
    {
      component = "resource_group"
    }
  )
}