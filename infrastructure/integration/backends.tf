terraform {
  backend "gcs" {
    bucket                      = "gde-ihommani-tf-state"
    prefix                      = "workflow-real-example-int/"
    impersonate_service_account = "workflow-real-example-tf@gde-ihommani.iam.gserviceaccount.com"
  }
}