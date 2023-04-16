locals {
  base_values =  yamldecode(templatefile("${path.module}/helm/values.yaml.tftpl", {
  }))

  merge_values = merge(local.base_values, try(var.extra_values.extra_values, {}))
}