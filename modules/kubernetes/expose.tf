# reserve a public ip for my application
resource "google_compute_global_address" "phpfpm-nginx-ip" {
  name = "phpfpm-nginx-ip"
}

# service of type ClusterIP for the deployment
resource "kubernetes_service" "phpfpm-nginx-service" {
  metadata {
    name = "phpfpm-nginx-service"
    namespace = kubernetes_namespace.dev.metadata[0].name
    annotations = {
      "cloud.google.com/neg" = "{\"ingress\": true}"
      "cloud.google.com/backend-config" = "{\"default\": \"my-backendconfig\"}"
    }
  }
  spec {
    selector = {
      "app"  = "phpfpm-nginx-example"
      "role" = "general"
    }
    port {
      port        = 80
      target_port = 80
    }
    type = "ClusterIP"
  }
  depends_on = [ 
    kubernetes_deployment.webapp_deploy,
    kubernetes_manifest.backendconfig
   ]
}

# expose the service to the internet

resource "kubernetes_ingress" "phpfpm-nginx-ingress" {
  metadata {
    name = "phpfpm-nginx-ingress"
    namespace = kubernetes_namespace.dev.metadata[0].name
    annotations = {
      "networking.gke.io/v1beta1.FrontendConfig" = "my-frontendconfig"
      "kubernetes.io/ingress.global-static-ip-name" = "phpfpm-nginx-ip"
    } 
  }
  spec {
    tls {
      secret_name = kubernetes_secret.tls_cred.metadata[0].name
    }
    backend {
      service_name = kubernetes_service.phpfpm-nginx-service.metadata[0].name
      service_port = 80
    }
  }
  depends_on = [ 
    kubernetes_secret.tls_cred,
    kubernetes_service.phpfpm-nginx-service,
    kubernetes_manifest.frontendconfig
   ]
}