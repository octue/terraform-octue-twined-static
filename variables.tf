variable "google_cloud_project_id" {
  type        = string
  description = "The ID of the google cloud project to deploy resources in."
}


variable "google_cloud_region" {
  type        = string
  description = "The google cloud region to deploy resources in."
}


variable "github_account" {
  type        = string
  description = "The name of the GitHub account to link to the workload identity federation provider. The provider is used to authenticate with google cloud in GitHub Actions workflows."
}


variable "maintainer_service_account_names" {
  type        = set(string)
  default     = ["default"]
  description = "The names of each maintainer IAM service account that should be created. They'll automatically be prefixed with 'maintainer-'."
}


variable "maximum_service_registry_instances" {
  type        = number
  default     = 10
  description = "The maximum number of instances to allow to be spun up simultaneously for the service registry. Each instance can handle one request at a time."
}


variable "deletion_protection" {
  type        = bool
  default     = true
  description = "Apply deletion protection to the event store and cloud storage bucket."
}
