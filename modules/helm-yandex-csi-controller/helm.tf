resource "helm_release" "ycc" {
  name       = var.release_name

  repository = var.chart_repo
  chart      = var.chart_name
  version    = var.chart_version

  namespace  = var.namespace
  create_namespace  = true

  values = [
    templatefile("templates/helm/yandex-csi-driver/values.yaml", {
        yandex_cloud_controller_sa  = local.yandex_k8s_csi_controller_sa_payload
        kubeApiServerIP = "https://${local.k8s_api_server}:${local.k8s_api_server_port}"
    })
  ]

  timeout   = 6000
  wait      = true
  atomic    = true
}
