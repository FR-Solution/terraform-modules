
resource "helm_release" "mcc" {
  depends_on = [
    helm_release.coredns
  ]
  name       = "mcc"
  chart      = "templates/helm/machine-controller-manager"
  namespace  = "fraima-ccm"

  create_namespace  = true
  timeout           = 6000
  wait              = true
  atomic            = true
}

