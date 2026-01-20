<div align="center"> 

  <h3 align="center">Azure Terraform Collection</h3>

  <p align="center">
    Opinionated, scalable Terraform modules for Azure workloads
    <br />
    <a href=""><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="">Live Preview</a>   
    
  </p>
</div>

<!-- ABOUT THE PROJECT -->
## About The Project

This repository provides a **structured and scalable way to build Azure infrastructure using Terraform**.

The main idea is simple:

- One **workload = one config.yaml**
- Terraform code stays centralized
- Infrastructure identity is derived from **folder naming**
- Safety rules (like prod locks) are enforced automatically

This approach is designed to:
- scale across many projects and environments
- minimize manual inputs
- reduce mistakes
- be CI/CD friendly



### Built With

The technologies used in this project include:
* [Terraform](https://www.terraform.io/)
* [AzureRM Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
* [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/)



<!-- GETTING STARTED -->
## Getting Started

This section explains how to **use this repository to deploy Azure infrastructure**.

The example below deploys:
- a Resource Group
- an App Service Plan



### Prerequisites

You need the following installed:

- [Terraform >= 1.5](https://www.terraform.io/downloads)
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
- An Azure subscription

Login to Azure:
```powershell
az login
````

If you use multiple tenants:

```powershell
az login --tenant "<TENANT_ID>"
```



### Repository Structure (simplified)

```text
azure-terraform-collection/
  modules/
    core/
      resource_group/
    paas/
      appservice/
        plan/

  environments/
    dev/
      example-module-test/
        providers.tf
        variables.tf
        locals.tf
        outputs.tf
        webapp_windows.tf
        D0001-EMT/
          config.yaml
        Q0001-EMT/
          config.yaml
        P0001-EMT/
          config.yaml
```

Terraform is always executed from the **stack folder**
(e.g. `environments/dev/example-module-test`).



### Naming Convention

Each workload folder must follow this format:

```text
<ENV><4 digits>-<PROJECT_CODE>
```

Examples:

* `D0001-EMT` → dev
* `Q0001-EMT` → qa
* `S0001-EMT` → stg
* `P0001-EMT` → prd

Environment mapping:

* `D` → dev
* `Q` → qa
* `S` → stg
* `P` → prd

The folder name is the **single source of truth** for:

* environment
* workload id
* project code



### config.yaml

Each workload folder contains **only one file**:

```text
D0001-EMT/
  config.yaml
```

Example `config.yaml`:

```yaml
web:
  farm:
    app:
      sku_name: B1
      worker_count: 1
      os_type: Linux
```

`config.yaml` is used only for **workload sizing and features**, not identity or environment.



### Installation / Deployment

#### 1. Go to the stack folder

```powershell
cd environments/dev/example-module-test
```

#### 2. Create `terraform.tfvars`

```hcl
subscription_id = "<YOUR_SUBSCRIPTION_ID>"
location        = "westeurope"
config_path     = "D0001-EMT/config.yaml"
```

Get your subscription ID:

```powershell
az account show --query id -o tsv
```


#### 3. Initialize Terraform

```powershell
terraform init -reconfigure
```


#### 4. Plan

```powershell
terraform plan
```


#### 5. Apply

```powershell
terraform apply
```

Type `yes` when prompted.


### What Will Be Created

From `D0001-EMT/config.yaml` in `westeurope`:

* Resource Group

  ```
  rg-dev-weu-EMT-0001
  ```

* App Service Plan

  ```
  asp-dev-weu-EMT-0001-app
  ```

Production workloads (`Pxxxx-*`) automatically receive:

* `CanNotDelete` resource group lock

Dev / QA / Stg do not.



### Deploy Another Environment

To deploy QA or Prod, change only:

```hcl
config_path = "Q0001-EMT/config.yaml"
```

or

```hcl
config_path = "P0001-EMT/config.yaml"
```

Then run:

```powershell
terraform apply
```



### Common Commands

```powershell
terraform init
terraform plan
terraform apply
terraform destroy
```



<!-- ROADMAP -->

## Roadmap

* [x] Resource Group module

  * [x] Automatic naming
  * [x] Prod-only lock enforcement
* [x] App Service Plan module

  * [x] YAML-driven sizing
  * [x] Folder-based identity
* [ ] Web App module (Linux / Windows / Container)
* [ ] Function App module
* [ ] CI/CD pipeline examples
* [ ] Policy & guardrails

---

## Key Principles (Important)

* Folder name = workload identity
* YAML = sizing & features only
* Terraform logic = environment & safety
* Prod safety is automatic, not manual

---

If you’re new to the repo:
👉 **Start by copying an existing workload folder and editing `config.yaml`.**
