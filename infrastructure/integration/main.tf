provider "google" {
  impersonate_service_account = "workflow-real-example-tf@gde-ihommani.iam.gserviceaccount.com"
}

resource "null_resource" "default" {
  provisioner "local-exec" {
    command = "echo 'Hello integration, how are you!!'"
  }
}

resource "null_resource" "default2" {
  provisioner "local-exec" {
    command = "echo 'I'm fine'"
  }
}

resource "null_resource" "default3" {
  provisioner "local-exec" {
    command = "echo 'I'm fine'"
  }
}

resource "google_project_service" "project" {
  project = "gde-ihommani"
  service = "run.googleapis.com"

  disable_on_destroy = false
}

resource "google_project_service" "gce" {
  project = "gde-ihommani"
  service = "run.googleapis.com"

  disable_on_destroy = false
}

resource "google_cloud_run_v2_service" "frontend" {
  name     = "cloudrun-service"
  location = "europe-west1"
  ingress  = "INGRESS_TRAFFIC_ALL"

  template {
    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
    }
  }
  depends_on = [google_project_service.gce]
}