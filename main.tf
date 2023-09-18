

# # get data about the cloud sql instance we want to connect to
# data "google_sql_database_instance" "appserver-db" {
#   name    = var.database_name
#   project = var.project
#   depends_on = [ module.cloud-sql ]
# }

# // get cluster endpoint from cloud storage
# data "google_storage_bucket_object_content" "cluster_endpoint" {
#   name   = "cluster-endpoint"
#   bucket = "kaustubhmali-tf-state-staging"
#   depends_on = [ module.gke-cluster ]
# }

# // get cluster certificate from cloud storage
# data "google_storage_bucket_object_content" "cluster_cert" {
#   name   = "cluster-cert"
#   bucket = "kaustubhmali-tf-state-staging"
#   depends_on = [ module.gke-cluster ]
# }

module "vpc" {
  source = "./modules/vpc"
}

module "subnet" {
  source                    = "./modules/subnets"
  name                      = "private"
  ip_cidr_range             = "10.0.0.0/18"
  region                    = var.region
  network                   = module.vpc.network
  secondary_ip_range_name_1 = var.secondary_ip_range_name_1
  secondary_ip_range_1      = "10.48.0.0/14"
  secondary_ip_range_name_2 = var.secondary_ip_range_name_2
  secondary_ip_range_2      = "10.52.0.0/20"
  depends_on                = [module.vpc]
}

module "router" {
  source      = "./modules/router"
  router_name = "router"
  region      = var.region
  network     = module.vpc.network
  depends_on  = [module.vpc]
}

module "nat" {
  source     = "./modules/nat"
  name       = "nat"
  router     = module.router.router
  region     = var.region
  subnet     = module.subnet.subnet_id
  depends_on = [module.router]
}

module "firewall" {
  source     = "./modules/firewall"
  name       = "allow-ssh"
  network    = module.vpc.network
  depends_on = [module.vpc]
}

module "gke-cluster" {
  source                        = "./modules/gke-cluster"
  name                          = var.cluster_name
  location                      = var.region
  network                       = module.vpc.network
  subnet_self_link              = module.subnet.subnet_self_link
  workload_pool_project         = var.project
  cluster_secondary_range_name  = var.secondary_ip_range_name_1
  services_secondary_range_name = var.secondary_ip_range_name_2
  depends_on                    = [module.subnet]
}

module "node-pools" {
  source     = "./modules/node-pools"
  cluster_id = module.gke-cluster.cluster_id
  depends_on = [module.gke-cluster]
}

module "cloud-sql" {
  source                   = "./modules/cloud-sql"
  name                     = var.database_name
  region                   = var.region
  authorized_network_name  = module.vpc.network
  authorized_network_value = "0.0.0.0/0"
  private_network          = module.vpc.network
  depends_on               = [module.vpc]
}

module "kubernetes" {
  source                 = "./modules/kubernetes"
  project                = var.project
  db_username            = var.user_name
  db_name                = var.database
  db_password            = var.user_password
  db_instance            = var.database_name
  db_instance_ip_address = module.cloud-sql.ip_address
  depends_on             = [module.gke-cluster]
}