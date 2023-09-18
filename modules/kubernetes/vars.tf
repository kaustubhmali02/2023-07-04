variable "project" {}
variable "namespace" {
  default = "dev"
}

variable "roles" {
  type = list(string)
  default = ["roles/cloudsql.client"]
  description = "for authenticating the cloud sql proxy side car container"
}

variable "db_username" {}
variable "db_name" {}
variable "db_instance" {}
variable "db_password" {}
variable "db_instance_ip_address" {}
variable "db_host" {
  type        = string
  default     = "127.0.0.1"
  description = "database host"
}
variable "image_name" {
  default = "docker.io/kaustubhmali/my-php-app:1.0.2"
}
variable "proxy_image" {
  default = "gcr.io/cloud-sql-connectors/cloud-sql-proxy:2.1.0"
}

variable "database_name" {
  default = "appserver-db"
}

variable "region" {
  default = "us-central1"
}