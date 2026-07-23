locals {
  apis = toset(
    [
      "artifactregistry.googleapis.com", # Artifact Registry is used to store docker images of the Twined services.
      "bigquery.googleapis.com",         # BigQuery provides the event store for Twined service events (questions, results, log messages etc.).
      "cloudbuild.googleapis.com",       # Cloud Build builds the service registry cloud function from its source code.
      "cloudfunctions.googleapis.com",   # Cloud Functions runs the service registry.
      "iam.googleapis.com",              # IAM provides fine-grained authentication and authorisation to use and access the Twined services and input/output data.
      "run.googleapis.com",              # Needed for cloud functions.
    ]
  )
}


resource "google_project_service" "google_apis" {
  for_each                   = local.apis
  service                    = each.key
  disable_dependent_services = false
  disable_on_destroy         = false
  project                    = var.google_cloud_project_id
}


resource "time_sleep" "wait_for_google_apis_to_enable" {
  depends_on      = [google_project_service.google_apis]
  create_duration = "1m"
}
