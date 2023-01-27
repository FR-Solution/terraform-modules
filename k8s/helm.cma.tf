
resource "helm_release" "cma" {
  depends_on = [
    helm_release.certmanager,
    helm_release.gatekeeper
  ]
  name       = "cma"
  chart      = "templates/helm/cluster-machine-approver"
  namespace  = "kube-fraima-ccm"
  timeout = 6000
  wait      = true
  atomic    = true
}
