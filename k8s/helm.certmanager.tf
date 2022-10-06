resource "helm_release" "certmanager" {
  depends_on = [null_resource.cluster]
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.9.1"
  namespace  = "fraima-certmanager"
  create_namespace  = true

  values = [
    templatefile("${path.module}/templates/helm/certmanager/values.yaml", {
    })
  ]
}