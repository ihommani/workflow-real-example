terraform {
  backend "gcs" {
    bucket = "gde-ihommani-tf-state"
    prefix = "workflow-real-example-int/"
  }
}