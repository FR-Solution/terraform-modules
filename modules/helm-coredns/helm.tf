resource "helm_release" "coredns" {
  name       = var.release_name

  repository = var.chart_repo
  chart      = var.chart_name
  version    = var.chart_version

  namespace  = var.namespace
  create_namespace  = true

  values = [
      templatefile("${path.module}/helm/values.yaml.tftpl", {
          clusterIP     = var.global_vars.k8s-addresses.dns_address
          extra_values  = var.extra_values
      })
      
  ]

  timeout   = 6000
  wait      = true
  atomic    = true
}
