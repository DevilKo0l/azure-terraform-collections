<div align="center">

  <h3 align="center">Azure Terraform Collection</h3>

  <p align="center">
    Opinionated, scalable Terraform modules for Azure workloads
    <br />
    <a href="#"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="#">View Demo</a>   
  </p>

</div>

---

## About The Project

This repository provides a structured and scalable way to build Azure infrastructure using Terraform.

The platform is designed around these principles:

- centralized Terraform orchestration
- reusable Azure modules
- workload-driven deployment
- environment-aware naming
- automated production safety
- scalable multi-environment configuration

The architecture separates responsibilities clearly:

| Layer                  | Responsibility                        |
| ---------------------- | ------------------------------------- |
| Root environment stack | orchestration, naming, config parsing |
| Reusable modules       | Azure resource creation only          |
| config.yaml            | workload sizing and features          |

This approach is designed to:

- scale across many projects and environments
- reduce duplicated Terraform logic
- enforce consistent naming
- minimize manual inputs
- support CI/CD pipelines
- improve governance and maintainability

---

### Architecture Overview

Deployment flow:

```text
config.yaml
    ↓
locals.global.tf
    ↓
platform naming + workload parsing
    ↓
environment orchestration
    ↓
reusable Azure modules
```

The root environment stack owns:

- workload parsing
- environment mapping
- naming conventions
- location mapping
- common tags
- production policies

Reusable modules only create Azure resources.

---

### Module Design Principles

Reusable modules must:

- create Azure resources only
- receive final values from the root stack
- validate inputs
- expose useful outputs
- remain environment-agnostic

Reusable modules must NOT:

- read config.yaml
- parse workload names
- build enterprise naming
- implement environment logic
- know production policies

---

### Root Stack Responsibilities

The root environment stack owns:

- config.yaml parsing
- workload selection
- naming conventions
- environment mapping
- location mapping
- shared tags
- production policies
- module orchestration

---

### Key Principles

- `config.yaml` = workload settings
- `target_workload` = deployment selector
- `locals.global.tf` = platform identity + naming
- modules = reusable Azure resources
- modules remain environment-agnostic

---

### Repository Structure

```text
azure-terraform-collection/
│
├── modules/
│   ├── core/
│   │   └── resource_group/
│   │
│   └── paas/
│       └── appservice/
│           ├── plan/
│           └── webapp/
│
└── environments/
    └── dev/
        └── example-module-test/
            ├── providers.tf
            ├── variables.tf
            ├── locals.global.tf
            ├── resource_group.tf
            ├── appservice_plan.tf
            ├── webapp.tf
            ├── outputs.tf
            ├── terraform.tfvars
            │
            ├── T0001-EMT/
            │   └── config.yaml
            │
            └── P0001-EMT/
                └── config.yaml
```

Terraform is always executed from the environment stack folder:

```powershell
cd environments/dev/example-module-test
```

---

### Workload Naming Convention

Workloads follow this format:

```text
<ENV><4 digits>-<PROJECT_CODE>
```

Examples:

| Workload  | Environment |
| --------- | ----------- |
| D0001-EMT | dev         |
| T0001-EMT | test        |
| S0001-EMT | stg         |
| P0001-EMT | prd         |

Environment mapping:

| Prefix | Environment |
| ------ | ----------- |
| D      | dev         |
| T      | test        |
| S      | stg         |
| P      | prd         |

The workload key is the source of truth for:

- environment
- workload ID
- project code

---

### Configuration Model

Each deployment group contains a single `config.yaml`.

Example:

```text
T0001-EMT/
  config.yaml
```

The file can contain multiple workloads.

Example:

```yaml
version: 1

environments:
  D0001-EMT:
    web:
      farm:
        app:
          sku_name: B1
          worker_count: 1
          os_type: Windows

      app:
        web:
          deploy_type: code
          https_only: true
          always_on: true

  T0001-EMT:
    web:
      farm:
        app:
          sku_name: B1
          worker_count: 1
          os_type: Windows

      app:
        web:
          deploy_type: code
          https_only: true
          always_on: true
```

`config.yaml` is used only for:

- workload sizing
- runtime configuration
- application settings
- optional workload features

`config.yaml` must NOT define:

- environment name
- workload ID
- project code
- resource group name
- naming conventions
- platform tags

Those are managed by the Terraform platform.

---

### Platform Naming Convention

All resources are generated from a shared naming suffix:

```text
<environment>-<location>-<project>-<workload_id>
```

Example:

```text
dev-weu-EMT-0001
```

Generated resource examples:

| Resource         | Example                  |
| ---------------- | ------------------------ |
| Resource Group   | rg-dev-weu-EMT-0001      |
| App Service Plan | asp-dev-weu-EMT-0001-app |
| Web App          | app-dev-weu-EMT-0001-web |

---

### Production Safety

Production workloads automatically receive additional protection.

If the workload starts with:

```text
P
```

Terraform automatically creates:

- `CanNotDelete` Resource Group lock

Non-production environments do not receive this lock.

This behavior is enforced automatically by the platform.

---

## Getting Started

### Prerequisites

Install the following:

- [Terraform](https://www.terraform.io/)
- [AzureRM Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/)

Login to Azure:

```powershell
az login
```

If using multiple tenants:

```powershell
az login --tenant "<TENANT_ID>"
```

---

### Deployment

1. Go to the environment stack

```powershell
cd environments/dev/example-module-test
```

---

2. Create terraform.tfvars

```hcl
subscription_id = "<YOUR_SUBSCRIPTION_ID>"
location        = "westeurope"

config_path     = "T0001-EMT/config.yaml"
target_workload = "D0001-EMT"
```

Get your subscription ID:

```powershell
az account show --query id -o tsv
```

---

3. Initialize Terraform

```powershell
terraform init -reconfigure
```

---

4. Validate

```powershell
terraform validate
```

---

5. Plan

```powershell
terraform plan
```

---

6. Apply

```powershell
terraform apply
```

Type:

```text
yes
```

when prompted.

---

### Example Deployment

Using:

```hcl
location        = "westeurope"
target_workload = "D0001-EMT"
```

Terraform creates:

Resource Group

```text
rg-dev-weu-EMT-0001
```

App Service Plan

```text
asp-dev-weu-EMT-0001-app
```

Windows Web App

```text
app-dev-weu-EMT-0001-web
```

---

#### Deploy Another Environment

To deploy another workload, change only:

```hcl
target_workload
```

Examples:

```hcl
target_workload = "T0001-EMT"
```

```hcl
target_workload = "S0001-EMT"
```

```hcl
target_workload = "P0001-EMT"
```

Then run:

```powershell
terraform apply
```

---

#### Common Terraform Commands

```powershell
terraform fmt
terraform validate
terraform plan
terraform apply
terraform destroy
```

---

## Roadmap

- [x] Resource Group module
- [x] App Service Plan module
- [x] Windows Web App module
- [ ] Linux Web App module
- [ ] Container Web App module
- [ ] Function App module
- [ ] Key Vault module
- [ ] Storage Account module
- [ ] Monitoring / Diagnostics module
- [ ] CI/CD pipeline examples
- [ ] Policy & governance examples
- [ ] Remote state bootstrap

---

## Recommended Workflow

```powershell
terraform fmt
terraform validate
terraform plan
terraform apply
```

---

## Notes

If you are new to the platform:

1. Copy an existing deployment group
2. Edit `config.yaml`
3. Change `target_workload`
4. Run Terraform

The platform automatically handles:

- naming
- environment mapping
- production safety
- tagging
- workload orchestration
