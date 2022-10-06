resource "helm_release" "gatekeeper" {
  depends_on = [null_resource.cluster]
  name       = "gatekeeper"
  chart      = "templates/helm/gatekeeper"
  namespace  = "fraima-gatekeeper"
  create_namespace  = true


}