
resource "helm_release" "cma" {
  depends_on = [helm_release.ycc]
  name       = "cma"
  chart      = "templates/helm/cluster-machine-approver"
  namespace  = "fraima-ccm"
  timeout = 6000
}
