data "archive_file" "service_registry" {
  type        = "zip"
  source_dir  = "${path.module}/functions/service_registry"
  output_path = "${path.module}/service_registry_source.zip"
  excludes    = ["__pycache__"]
}


resource "google_storage_bucket" "function_source" {
  name                        = "${var.google_cloud_project_id}-octue-twined-function-source"
  location                    = var.google_cloud_region
  uniform_bucket_level_access = true

  # The source archives are build artefacts that can be regenerated from this module at any time.
  force_destroy = true

  depends_on = [time_sleep.wait_for_google_apis_to_enable]
}


resource "google_storage_bucket_object" "service_registry_source" {
  # Including the archive's hash in the object name is what makes the cloud function redeploy when the source changes.
  name   = "service_registry/${data.archive_file.service_registry.output_md5}.zip"
  bucket = google_storage_bucket.function_source.name
  source = data.archive_file.service_registry.output_path
}


resource "google_cloudfunctions2_function" "service_registry" {
  name        = "octue-twined-service-registry"
  description = "A lightweight service registry for Octue Twined services running on Kueue."
  location    = var.google_cloud_region

  build_config {
    runtime     = "python312"
    entry_point = "handle_request"
    source {
      storage_source {
        bucket = google_storage_bucket_object.service_registry_source.bucket
        object = google_storage_bucket_object.service_registry_source.name
      }
    }
  }

  service_config {
    max_instance_count = var.maximum_service_registry_instances
    available_memory   = "256M"
    timeout_seconds    = 60
    environment_variables = {
      ARTIFACT_REGISTRY_REPOSITORY_ID = "projects/${var.google_cloud_project_id}/locations/${var.google_cloud_region}/repositories/${google_artifact_registry_repository.service_docker_images.repository_id}"
    }
  }

  depends_on = [time_sleep.wait_for_google_apis_to_enable]
}
