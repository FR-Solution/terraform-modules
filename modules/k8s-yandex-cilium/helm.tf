resource "helm_release" "cilium" {
  name       = var.release_name

  repository = var.chart_repo
  chart      = var.chart_name
  version    = var.chart_version

  namespace  = var.namespace
  create_namespace  = true

  values = [
    templatefile("${path.module}/helm/values.yaml.tftpl", {
      k8s_api_server_fqdn     = local.k8s_api_server
      k8s_api_server_port     = local.k8s_api_server_port
      cluster_name            = local.cluster_name
      cluster_id              = var.cluster_id
      extra_values            = var.extra_values
    })
  ]

  timeout   = 6000
  wait      = true
  atomic    = true
}
