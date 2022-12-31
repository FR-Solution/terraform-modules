resource "helm_release" "base-roles" {
  depends_on = [
    module.k8s-yandex-cluster,
  ]
  name       = "base-roles"
  chart      = "templates/helm/base-roles"
  namespace  = "kube-system"
  values = []
  atomic    = true
}
