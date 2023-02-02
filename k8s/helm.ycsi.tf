
# resource "helm_release" "ycsi" {
#   depends_on = [
#     module.cilium
#   ]

#   name       = "yandex"

#   repository = "https://helm.fraima.io"
#   chart      = "yandex-csi-controller"
#   version    = "0.0.4"

#   namespace  = "kube-fraima-csi"
#   create_namespace  = true
#   values = [
#     templatefile("templates/helm/yandex-csi-driver/values.yaml", {
#         yandex_cloud_controller_sa  = local.yandex-k8s-controllers-sa
#         kubeApiServerIP = "https://${local.k8s_api_server}:${local.k8s_api_server_port}"
#     })
#   ]
#   timeout   = 6000
#   wait      = true
#   atomic    = true
# }
