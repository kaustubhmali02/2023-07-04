variable "project" {
  default = "kata-2023-07-04"
}
variable "region" {
  default = "us-central1"
}
variable "secondary_ip_range_name_1" {
  default = "k8s-pod-range"
}
variable "secondary_ip_range_name_2" {
  default = "k8s-service-range"
}
variable "database_name" {
  default = "appserver-db"
}
variable "cluster_name" {
  default = "primary"
}
variable "user_name" {
  default = "mysql"
}
variable "user_password" {
  default = "Password@123"
}
variable "database" {
  default = "model_application"
}
# variable "service_account" {
# }
# variable "metadata_startup_script" {
#   default = "sudo apt-get update && sudo apt-get install -y curl openssh-server ca-certificates perl && curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh | sudo bash"
# }
# variable "db_name" {
#   default = "website_test"
# }
# variable "db_user" {
#   default = "website"
# }
# variable "db_password" {
#   default = "dbpassword"
# }
# variable "website_ports" {
#   type = list(object({name = string, port = number}))
#   default = [
#     {name = "http", port = 80},
#     {name = "ssh", port = 22}
#   ]
# }