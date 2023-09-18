//creates secret for the tls cert and key
resource "kubernetes_secret" "tls_cred" {
  metadata {
    name      = "tls-cred"
    namespace = kubernetes_namespace.dev.metadata[0].name
  }

  data = {
    tls_crt = file("${path.root}/.tls/certificate.cer")
    # "tls.crt" = var.tls_crt
    # "tls.key" = var.tls_key
    tls_key = file("${path.root}/.tls/private_key.key")
  }

  type = "kubernetes.io/tls"
}
