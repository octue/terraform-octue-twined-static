terraform {
  required_version = ">= 1.8.0, <2"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~>6.12"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~>2.4"
    }
  }
}


data "google_project" "project" {}
