
resource "helm_release" "ycsi" {
  depends_on = [
    helm_release.coredns,
  ]
  name       = "yandex"
  chart      = "templates/helm/yandex-csi-driver"
  namespace  = "kube-fraima-csi"
  create_namespace  = true
  values = [
    templatefile("templates/helm/yandex-csi-driver/values.yaml", {
        yandex_csi_driver_sa_sa = local.yandex-k8s-controllers-sa
        cluster_name = var.cluster_name
    })
  ]
  timeout   = 6000
  wait      = true
  atomic    = true
}
