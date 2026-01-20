module "rg" {
  source = "../../../modules/core/resource_group"

  location             = var.location
  workload_folder_name = local.workload_folder

  tags = local.common_tags
  # lock_in_prod_only = true  # default, can omit
}