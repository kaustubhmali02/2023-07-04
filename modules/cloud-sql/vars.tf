variable "name" {}
variable "region" {}
variable "authorized_network_name" {}
variable "authorized_network_value" {}
variable "ipv4_enabled" {
  default = true
}
variable "private_network" {}
variable "user_name" {
  default = "mysql"
}
variable "user_password" {
  default = "Password@123"
}
variable "database_name" {
  default = "model_application"
}