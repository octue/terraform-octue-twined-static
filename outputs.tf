output "artifact_registry_repository_name" {
  value       = google_artifact_registry_repository.service_docker_images.name
  description = "The name of the artifact registry repository storing Twined service revision images."
}


output "storage_bucket_url" {
  value       = google_storage_bucket.default.url
  description = "The `gs://` URL of the storage bucket used to store service inputs, outputs, and diagnostics."
}


output "event_store_id" {
  value       = "${google_bigquery_dataset.service_event_dataset.dataset_id}.${google_bigquery_table.service_event_table.table_id}"
  description = "The ID of the BigQuery table used as the event store. Provide in '<dataset-name>.<table-name>' format."
}


output "service_registry_url" {
  value       = google_cloudfunctions2_function.service_registry.url
  description = "The URL of the service registry."
}
