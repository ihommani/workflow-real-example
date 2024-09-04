provider "google" {
  impersonate_service_account = "workflow-real-example-tf@gde-ihommani.iam.gserviceaccount.com"
}

resource "null_resource" "default" {
  provisioner "local-exec" {
    command = "echo 'Hello integration, how are you'"
  }
}

resource "null_resource" "echo_smthg" {
  provisioner "local-exec" {
    command = "echo 'I have my poney course'"
  }
}

resource "null_resource" "echo_smthg_more" {
  provisioner "local-exec" {
    command = "echo 'I have swimming pool'"
  }
}

resource "null_resource" "echo_smthg_useful" {
  provisioner "local-exec" {
    command = "echo 'I have poney'"
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