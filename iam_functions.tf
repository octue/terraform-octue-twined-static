resource "google_cloud_run_service_iam_member" "service_registry_invoker" {
  for_each   = local.maintainer_service_account_emails
  service    = google_cloudfunctions2_function.service_registry.name
  location   = google_cloudfunctions2_function.service_registry.location
  role       = "roles/run.invoker"
  member     = each.value
  depends_on = [time_sleep.wait_for_google_apis_to_enable]
}
