# get gcloud authentication information
data "google_client_config" "default" {}

# https://www.terraform.io/language/settings/backends/gcs
terraform {
  backend "gcs" {
    bucket = "kaustubhmali-tf-state-staging"
    prefix = "terraform"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.59.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.22.0"
    }
  }
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs
provider "google" {
  project = var.project
  region  = var.region
}

# get information about cluster
data "google_container_cluster" "primary_cluster" {
  name = var.cluster_name
  # project  = var.project
  location = "${var.region}-a"
  depends_on = [ module.gke-cluster ]
}

# https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs
provider "kubernetes" {
  host  = "https://${data.google_container_cluster.primary_cluster.endpoint}"
  token = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.primary_cluster.master_auth[0].cluster_ca_certificate,
  )
}