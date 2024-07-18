provider "google" {
  impersonate_service_account = "workflow-real-example-tf@gde-ihommani.iam.gserviceaccount.com"
}

resource "null_resource" "default" {
  provisioner "local-exec" {
    command = "echo 'Hello integration, how are you'"
  }
}

resource "google_cloud_run_service" "default" {
  name     = "cloudrun-srv"
  location = "europe-west1"
  project  = "gde-ihommani"

  template {
    spec {
      containers {
        image = "europe-west1-docker.pkg.dev/gde-ihommani/to-delete/frontend:latest"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}