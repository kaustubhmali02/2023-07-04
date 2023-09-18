# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork
resource "google_compute_subnetwork" "private" {
  name                     = var.name
  ip_cidr_range            = var.ip_cidr_range
  region                   = var.region
  network                  = var.network
  private_ip_google_access = true

  secondary_ip_range {
    range_name    = var.secondary_ip_range_name_1
    ip_cidr_range = var.secondary_ip_range_1
  }
  secondary_ip_range {
    range_name    = var.secondary_ip_range_name_2
    ip_cidr_range = var.secondary_ip_range_2
  }
}