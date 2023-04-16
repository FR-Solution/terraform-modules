locals {
  default_values =  yamldecode(templatefile("${path.module}/helm/common.yaml", {
  }))

  base_values =  yamldecode(templatefile("${path.module}/helm/vm-operator.yaml", {
    release_name  = try(var.extra_values.release_name   ,var.release_name)
  }))

  merge_default = merge(local.default_values, local.base_values)
  merge_values  = merge(local.merge_default, var.extra_values)
}