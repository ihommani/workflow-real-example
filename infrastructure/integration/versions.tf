terraform {

  required_version = ">= 1.5.7, < 2.0.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.15.0, < 6.0.0"
    }
  }

}