locals {
  base_values =  yamldecode(templatefile("${path.module}/helm/values.yaml.tftpl", {
    clusterIP     = var.global_vars.k8s-addresses.dns_address
  }))

  merge_values = merge(local.base_values, try(var.extra_values.extra_values, {}))
}