resource "google_project_iam_member" "cloud_build__service_agent" {
  project    = var.google_cloud_project_id
  role       = "roles/cloudbuild.serviceAgent"
  member     = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-cloudbuild.iam.gserviceaccount.com"
  depends_on = [time_sleep.wait_for_google_apis_to_enable]
}


resource "google_project_iam_member" "cloud_build__service_usage_consumer" {
  project    = var.google_cloud_project_id
  role       = "roles/serviceusage.serviceUsageConsumer"
  member     = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-cloudbuild.iam.gserviceaccount.com"
  depends_on = [time_sleep.wait_for_google_apis_to_enable]
}


resource "google_project_iam_member" "cloud_functions__service_agent" {
  project    = var.google_cloud_project_id
  role       = "roles/cloudfunctions.serviceAgent"
  member     = "serviceAccount:service-${data.google_project.project.number}@gcf-admin-robot.iam.gserviceaccount.com"
  depends_on = [time_sleep.wait_for_google_apis_to_enable]
}


resource "google_project_iam_member" "cloud_functions__service_usage_consumer" {
  project    = var.google_cloud_project_id
  role       = "roles/serviceusage.serviceUsageConsumer"
  member     = "serviceAccount:service-${data.google_project.project.number}@gcf-admin-robot.iam.gserviceaccount.com"
  depends_on = [time_sleep.wait_for_google_apis_to_enable]
}
