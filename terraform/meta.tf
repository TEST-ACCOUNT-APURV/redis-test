data "humanitec_source_ip_ranges" "main" {}

data "google_client_config" "default" {}

data "http" "icanhazip" {
   url = "http://icanhazip.com"
}

data "kubernetes_service" "ingress_nginx_controller" {
  metadata {
    name      = "ingress-nginx-controller"
    namespace = "ingress-nginx"
  }
  depends_on = [helm_release.ingress_nginx]
}