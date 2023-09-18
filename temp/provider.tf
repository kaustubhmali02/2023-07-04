# data "google_client_config" "default" {}

# # get information about cluster
# data "google_container_cluster" "primary_cluster" {
#   name     = var.cluster_name
#   # project  = var.project
#   location = "${var.region}-a"
# }

# # https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs
# provider "kubernetes" {
#   host  = "https://${data.google_container_cluster.primary_cluster.endpoint}"
#   token = data.google_client_config.default.access_token
#   cluster_ca_certificate = base64decode(
#     data.google_container_cluster.primary_cluster.master_auth[0].cluster_ca_certificate,
#   )
# }