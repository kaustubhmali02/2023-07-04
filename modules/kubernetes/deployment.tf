resource "kubernetes_deployment" "webapp_deploy" {
  metadata {
    name      = "phpfpm-nginx-example"
    namespace = kubernetes_namespace.dev.metadata[0].name
    labels = {
      "app"  = "phpfpm-nginx-example"
      "role" = "general"
    }
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        "app"  = "phpfpm-nginx-example"
        "role" = "general"
      }
    }
    template {
      metadata {
        labels = {
          "app" = "phpfpm-nginx-example"
        }
      }
      spec {
        service_account_name = kubernetes_service_account.kube_sa.metadata[0].name
        container {
          name  = "app"
          image = var.image_name
          port {
            container_port = 80
          }
          env {
            name  = "DB_HOST"
            value = var.db_host
          }
          env {
            name  = "DB_USER"
            value = var.db_username
          }
          env {
            name  = "DB_PASSWORD"
            value = var.db_password
          }
          env {
            name  = "DB_NAME"
            value = var.db_name
          }
          lifecycle {
            post_start {
              exec {
                command = [
                  "/bin/sh",
                  "-c",
                  "cp -r /app/. /var/www/html"
                ]
              }
            }
          }
          resources {
            limits = {
              "cpu"    = "500m"
              "memory" = "128Mi"
            }
            requests = {
              "cpu"    = "250m"
              "memory" = "64Mi"
            }
          }
          volume_mount {
            mount_path = "/var/www/html"
            name = "shared-files"
          }
        }
        container {
          name  = "nginx"
          image = "nginx:latest"
          port {
            container_port = 80
          }
          resources {
            limits = {
              "cpu"    = "500m"
              "memory" = "128Mi"
            }
            requests = {
              "cpu"    = "250m"
              "memory" = "64Mi"
            }
          }
          volume_mount {
            mount_path = "/var/www/html"
            name      = "shared-files"
              
          }
          volume_mount {
            mount_path = "/etc/nginx/nginx.conf"
            name = "nginx-config-volume"
            sub_path = "nginx.conf"
          }
        }
        container {
          name  = "cloud-sql-proxy"
          image = var.proxy_image
          args = [
            "--private-ip",
            "--structured-logs",
            "--port=3306",
            "${var.db_instance}"
          ]
          security_context {
            run_as_non_root = true
          }
          resources {
            limits = {
              "cpu"    = "500m"
              "memory" = "128Mi"
            }
            requests = {
              "cpu"    = "250m"
              "memory" = "64Mi"
            }
          }
        }
        toleration {
          key = "instance_type"
          operator = "Equal"
          value = "spot"
          effect = "NO_SCHEDULE"
        }
        volume {
          empty_dir {}
          name = "shared-files"
        }
        volume {
          config_map {
            name = "nginx-config"
          }
          name = "nginx-config-volume"
        }
      }
    }
  }
  depends_on = [ kubernetes_config_map.nginx-config ]
}
