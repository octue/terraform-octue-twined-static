# terraform-octue-twined-core
A Terraform module for deploying the core storage and IAM resources for an Octue Twined services network to google cloud.  

> [!IMPORTANT]
> To deploy an Octue Twined services network, you need two terraform modules. This module ("core") provides infrastructure for
> storing data and code. The [other ("cluster")](https://github.com/octue/terraform-octue-twined-cluster) provides a job queue
> and compute resources (a kubernetes cluster) for running analyses.
> A complete example using both modules can be found [here](https://github.com/octue/twined-infrastructure).

> [!TIP]
> Having the cluster in a separate module allows you to destroy it whilst keeping previously stored results.
> This saves on running costs in periods of extended non-use (keeping a minimal cluster ready to run analyses costs c.$30/month).

# Infrastructure
These resources are automatically deployed:
- An artifact registry repository for storing Octue Twined service revision docker images
- A BigQuery table acting as an event store for Twined service events
- IAM service accounts and roles for:
  - Any number of maintainers to use with Twined services
  - GitHub Actions to a) build and push Twined service images to the artifact registry; b) test services
- A workload identity pool and provider allowing GitHub actions to authenticate with google cloud
- A cloud storage bucket to store input, output, and diagnostics data for Twined services


# Installation and usage
Add the below blocks to your Terraform configuration and run:
```shell
terraform init
terraform plan
```

If you're happy with the plan, run:
```shell
terraform apply
```
and approve the run.

## Example configuration

```terraform
# main.tf

terraform {
  required_version = ">= 1.8.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~>6.12"
    }
  }
}


provider "google" {
  project = var.google_cloud_project_id
  region  = var.google_cloud_region
}
        

module "octue_twined_core" {
  source = "git::github.com/octue/terraform-octue-twined-core.git?ref=0.1.2"
  google_cloud_project_id          = var.google_cloud_project_id
  google_cloud_region              = var.google_cloud_region
  github_account                   = var.github_account
}
```

```terraform
# variables.tf

variable "google_cloud_project_id" {
  type    = string
  default = "<google-cloud-project-id>"
}

variable "google_cloud_region" {
  type    = string
  default = "<google-cloud-region>"
}

variable "github_account" {
  type    = string
  default = "<your-github-account>"
}
```

## Dependencies
- Terraform: `>= 1.8.0, <2`
- Providers:
  - `hashicorp/google`: `~>6.12`
- Google cloud APIs:
  - The Cloud Resource Manager API must be [enabled manually](https://console.developers.google.com/apis/api/cloudresourcemanager.googleapis.com) 
    before using the module
  - All other required google cloud APIs are enabled automatically by the module 

## Authentication
The module needs to authenticate with google cloud before it can be used:

1. Create a service account for Terraform and assign it the `editor` and `owner` basic IAM permissions
2. Download a JSON key file for the service account
3. If using Terraform Cloud, follow [these instructions](https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_reference#using-terraform-cloud).
   before deleting the key file from your computer 
4. If not using Terraform Cloud, follow [these instructions](https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_reference#authentication-configuration)
   or use another [authentication method](https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_reference#authentication).


## Destruction
> [!WARNING]
> If the `deletion_protection` input is set to `true`, it must first be set to `false` and `terraform apply` run before 
> running `terraform destroy` or any other operation that would result in the destruction or replacement of the cloud 
> storage bucket or event store BigQuery table. Not doing this can lead to a state needing targeted Terraform commands 
> and/or manual configuration changes to recover from.

Disable `deletion_protection` and run:
```shell
terraform destroy
```


# Input reference

| Name                                | Type          | Required | Default       |
|-------------------------------------|---------------|----------|---------------| 
| `google_cloud_project_id`           | `string`      | Yes      | N/A           |  
| `google_cloud_region`               | `string`      | Yes      | N/A           | 
| `github_account`                    | `string`      | Yes      | N/A           |                 
| `maintainer_service_account_names`  | `set(string)` | No       | `["default"]` | 
| `deletion_protection`               | `bool`        | No       | `true`        | 

See [`variables.tf`](/variables.tf) for descriptions.


# Output reference

| Name                                | Type     |
|-------------------------------------|----------|
| `artifact_registry_repository_name` | `string` | 
| `storage_bucket_url`                | `string` | 
| `event_store_id`                    | `string` | 

See [`outputs.tf`](/outputs.tf) for descriptions.
