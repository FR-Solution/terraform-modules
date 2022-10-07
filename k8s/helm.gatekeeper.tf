resource "helm_release" "gatekeeper" {
  depends_on = [helm_release.coredns]
  name       = "gatekeeper"
  chart      = "templates/helm/gatekeeper"
  namespace  = "fraima-gatekeeper"
  create_namespace  = true

  values = [
    file("${path.module}/templates/helm/gatekeeper/values-extra.yaml")
  ]
}