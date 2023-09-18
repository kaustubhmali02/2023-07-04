resource "google_compute_global_address" "private_ip_block" {
  name          = "private-ip-block"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  ip_version    = "IPV4"
  prefix_length = 20
  network       = var.authorized_network_name
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = var.authorized_network_name
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_block.name]
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance
resource "google_sql_database_instance" "main" {
  name             = var.name
  database_version = "MYSQL_5_7"
  depends_on          = [google_service_networking_connection.private_vpc_connection]
  region           = var.region
  deletion_protection = false

  settings {
    # Second-generation instance tiers are based on the machine
    # type. See argument reference below.
    tier = "db-f1-micro"
  
    ip_configuration {
        authorized_networks {
            name  = var.authorized_network_name
            value = var.authorized_network_value
        }
        ipv4_enabled = true
        private_network = var.private_network
        
    }
  }
}

resource "google_sql_user" "users" {
  name     = var.user_name
  instance = google_sql_database_instance.main.name
  password = var.user_password
}

resource "google_sql_database" "database" {
  name     = var.database_name
  instance = google_sql_database_instance.main.name
}