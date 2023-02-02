resource "helm_release" "ycc" {
  name       = var.release_name

  repository = var.chart_repo
  chart      = var.chart_name
  version    = var.chart_version

  namespace  = var.namespace
  create_namespace  = true
  values = [
    templatefile("${path.module}/helm/values.yaml.hcl", {
        yandex_cloud_controller_sa  = local.yandex_k8s_controllers_sa_payload
        cluster_name                = local.cluster_name
        pod_cidr                    = local.pod_cidr
        k8s_api_server              = local.k8s_api_server_ip
        k8s_api_server_port         = local.k8s_api_server_port
        extra_values                = var.extra_values
    })
  ]
  timeout   = 6000
  wait      = true
  atomic    = true
}
