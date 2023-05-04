terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}
provider "google" {
  version = "3.5.0"
  project = "my-project-13971-challenge"
  region  = "us-central1"
  zone    = "us-central1-c"
}
# New resource for the storage bucket our application will use.
resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}
resource "google_storage_bucket" "theo-gigabucket-04052023" {
  name     = "theo-gigabucket-04052023"
  location = "US"
  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
}

#creating the archive ressource to pass it to the function
resource "google_storage_bucket_object" "theo-archive13971" {
  depends_on = [google_storage_bucket.theo-gigabucket-04052023]
  name   = "function-13971.zip"
  bucket = google_storage_bucket.theo-gigabucket-04052023.name
  source = "function-13971.zip"
}
resource "google_cloudfunctions_function" "theo-function-13971" {
  depends_on = [google_storage_bucket_object.theo-archive13971]
  name        = "theo-function-13971"
  description = "a function that executes some code from some zipfile"
  runtime     = "nodejs14"

  source_archive_bucket = google_storage_bucket.theo-gigabucket-04052023.name
  source_archive_object = google_storage_bucket_object.theo-archive13971.name
  entry_point           = "helloWorld"
  timeout               = 60

  event_trigger {
    event_type = "google.storage.object.finalize"
    resource   = "theo-gigabucket-04052023"
    failure_policy {
      retry = false
    }
  }
}
resource "google_bigquery_dataset" "theo-bigqdataset-13971" {
  dataset_id                  = "dataset13971"
  location                    = "US"
  default_table_expiration_ms = "3600000"
}

resource "google_bigquery_table" "theo-bigqtable-13971" {
  depends_on = [google_bigquery_dataset.theo-bigqdataset-13971]
  dataset_id = google_bigquery_dataset.theo-bigqdataset-13971.dataset_id
  table_id   = "theo-table-13971"

  time_partitioning {
    type = "DAY"
  }

  schema = <<EOF
[
  {
    "name": "column1",
    "type": "STRING"
  },
  {
    "name": "column2",
    "type": "INTEGER"
  }
]
EOF
}





