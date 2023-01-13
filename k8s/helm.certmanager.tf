resource "helm_release" "certmanager" {
  depends_on = [
    helm_release.coredns,
  ]
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.9.1"
  namespace  = "kube-fraima-certmanager"
  create_namespace  = true

  values = [
    templatefile("${path.module}/templates/helm/certmanager/values.yaml", {
    })
  ]
  wait      = true
  atomic    = true
}