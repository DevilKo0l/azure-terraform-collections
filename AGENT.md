I am building an Azure Terraform platform with this architecture.

Repository structure:

azure-terraform-collection/
modules/
core/
resource_group/
paas/
appservice/
plan/
webapp/

environments/
dev/
example-module-test/
providers.tf
variables.tf
locals.global.tf
resource_group.tf
appservice_plan.tf
webapp.tf
terraform.tfvars
T0001-EMT/
config.yaml
P0001-EMT/
config.yaml

Terraform is always executed from the environment stack folder, for example:

environments/dev/example-module-test

Architecture rules:

1. The root environment stack owns all platform logic:
   - reading config.yaml
   - selecting target workload
   - parsing workload key
   - environment mapping
   - location short code
   - naming convention
   - common tags
   - production lock policy

2. Reusable modules must NOT:
   - read config.yaml
   - parse folder names
   - parse workload keys
   - know about environments
   - build enterprise naming from environment/project/workload
   - contain platform-specific logic

3. Reusable modules should only:
   - create one Azure resource or one clear resource group
   - accept final values as variables
   - apply simple defaults
   - validate inputs
   - output created resource properties

Workload model:

config.yaml contains multiple workloads:

version: 1

environments:
D0001-EMT:
web:
farm:
app:
sku_name: B1
worker_count: 1
os_type: Linux

T0001-EMT:
web:
farm:
app:
sku_name: B1
worker_count: 1
os_type: Linux

Deployment is selected by terraform.tfvars:

subscription_id = "<subscription-id>"
location = "westeurope"
config_path = "T0001-EMT/config.yaml"
target_workload = "D0001-EMT"

Workload naming convention:

<ENV><4 digits>-<PROJECT_CODE>

Examples:
D0001-EMT = dev
T0001-EMT = test
S0001-EMT = staging
P0001-EMT = production

Environment mapping:
D = dev
T = test
S = stg
P = prd

The target_workload is the source of truth for:

- environment
- workload ID
- project code

config.yaml is only for workload sizing and features.
It should not define resource group name, environment, project code, workload ID, or common tags.

Global locals in the root stack produce:

local.environment
local.env_code
local.workload_id
local.project_code
local.location_short
local.resource_suffix
local.resource_group_name
local.common_tags
local.resource_group_lock_enabled
local.workload_config

Naming convention:

resource_suffix = "<environment>-<location_short>-<PROJECT_CODE>-<workload_id>"

Examples:
resource group: rg-dev-weu-EMT-0001
app service plan: asp-dev-weu-EMT-0001-app
web app: app-dev-weu-EMT-0001-web

Production behavior:
If env_code == "P", resource group lock is enabled.
Other environments do not get a lock.

Module design requirement:

For every reusable module, generate:

- main.tf
- variables.tf
- outputs.tf
- optional locals.tf only for internal module normalization

The module should receive ready-to-use values from the root stack.

Example module call style:

module "resource_group" {
source = "../../../modules/core/resource_group"

name = local.resource_group_name
location = var.location
lock_enabled = local.resource_group_lock_enabled
tags = local.common_tags
}

module "app_service_plan" {
source = "../../../modules/paas/appservice/plan"

name = "asp-${local.resource_suffix}-app"
location = var.location
resource_group_name = module.resource_group.name

sku_name = try(local.workload_config.web.farm.app.sku_name, "B1")
worker_count = try(local.workload_config.web.farm.app.worker_count, 1)
os_type = try(local.workload_config.web.farm.app.os_type, "Linux")

tags = local.common_tags
}

Please write Terraform module code that fits this architecture.
Do not put platform logic inside the module.
Keep the module simple, reusable, validated, and production-friendly.
