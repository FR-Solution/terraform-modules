
# resource "helm_release" "monitoring" {
#   depends_on = [
#     helm_release.certmanager,
#     helm_release.gatekeeper
#   ]
#   name       = "monitoring"
#   namespace  = "kube-fraima-monitoring"

#   repository = "https://victoriametrics.github.io/helm-charts/"
#   chart      = "victoria-metrics-operator"
#   version    = "0.17.2"

#   create_namespace  = true
#   timeout           = 6000
#   wait              = true
#   atomic            = true
# }
