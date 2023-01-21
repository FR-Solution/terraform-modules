
# resource "helm_release" "mcc" {
#   depends_on = [
#     helm_release.certmanager,
#     helm_release.gatekeeper
#   ]
#   name       = "mcc"
#   namespace  = "kube-fraima-ccm"

#   repository = "https://helm.fraima.io"
#   chart      = "cluster-machine-controller"
#   version    = "0.0.3"

#   create_namespace  = true
#   timeout           = 6000
#   wait              = true
#   atomic            = true
# }
