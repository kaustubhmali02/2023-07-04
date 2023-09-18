/* this file contains the custom resource defintions used to include http redirect(frontendconfig)
 and custom health checks (backendconfig) */

//custom resource definition for backendconfig
resource "kubernetes_manifest" "backendconfig" {
  manifest = {
    "apiVersion" = "cloud.google.com/v1"
    "kind" = "BackendConfig"
    "metadata" = {
      "name" = "my-backendconfig"
      "namespace" = "${kubernetes_namespace.dev.metadata[0].name}"
    }
    "spec" = {
      "healthCheck" = {
        "checkIntervalSec" = 15
        "healthyThreshold" = 1
        "port" = 80
        "requestPath" = "/webapp"
        "timeoutSec" = 15
        "type" = "HTTP"
        "unhealthyThreshold" = 2
      }
      "timeoutSec" = 45
      "sessionAffinity" = {
        "affinityType" = "CLIENT_IP"
      }
   }
 }
 depends_on = [ kubernetes_service_account.kube_sa ]
}

//custom resource definition for frontendconfig
resource "kubernetes_manifest" "frontendconfig" {
  manifest = {
    "apiVersion" = "networking.gke.io/v1beta1"
    "kind" = "FrontendConfig"
    "metadata" = {
      "name" = "my-frontendconfig"
      "namespace" = "${kubernetes_namespace.dev.metadata[0].name}"
    }
    "spec" = {
      "redirectToHttps" = {
          "enabled" = true
      }
    }
  }
  depends_on = [ random_id.service_account ]
}
