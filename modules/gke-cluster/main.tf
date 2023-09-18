# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster
resource "google_container_cluster" "primary" {
  name                     = var.name
  location                 = "${var.location}-a"
  remove_default_node_pool = true
  initial_node_count       = 1
  network                  = var.network
  subnetwork               = var.subnet_self_link
  logging_service          = "logging.googleapis.com/kubernetes"
  monitoring_service       = "monitoring.googleapis.com/kubernetes"
  networking_mode          = "VPC_NATIVE"

  # Optional, if you want multi-zonal cluster
  node_locations = [
    "${var.location}-b"
  ]

  addons_config {
    http_load_balancing {
      disabled = true
    }
    horizontal_pod_autoscaling {
      disabled = false
    }
  }

  release_channel {
    channel = "REGULAR"
  }

  workload_identity_config {
    workload_pool = "${var.workload_pool_project}.svc.id.goog"
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = var.cluster_secondary_range_name
    services_secondary_range_name = var.services_secondary_range_name
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }

  #   Jenkins use case
  #   master_authorized_networks_config {
  #     cidr_blocks {
  #       cidr_block   = "10.0.0.0/18"
  #       display_name = "private-subnet-w-jenkins"
  #     }
  #   }
}

# // export the cluster ca certificate to a cloud storage bucket
# resource "google_storage_bucket_object" "cluster_cert" {
#   name   = "cluster-cert"
#   content = "${google_container_cluster.primary.master_auth[0].cluster_ca_certificate}"
#   bucket = "kaustubhmali-tf-state-staging"
#   depends_on = [ google_container_cluster.primary ]
# }


# // export the cluster endpoint to a cloud storage bucket
# resource "google_storage_bucket_object" "cluster_endpoint" {
#   name   = "cluster-endpoint"
#   content = "${google_container_cluster.primary.endpoint}"
#   bucket = "kaustubhmali-tf-state-staging"
#   depends_on = [ google_container_cluster.primary ]
# }