
resource "helm_release" "cma" {
  depends_on = [
    helm_release.coredns
  ]
  name       = "cma"
  chart      = "templates/helm/cluster-machine-approver"
  namespace  = "fraima-ccm"
  timeout = 6000
  wait      = true
  atomic    = true
}
