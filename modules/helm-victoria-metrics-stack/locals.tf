locals {
  base_values =  yamldecode(templatefile("${path.module}/helm/values.yaml.tftpl", {
    release_name  = try(var.extra_values.release_name   ,var.release_name)
  }))

  merge_values = merge(local.base_values, var.extra_values)
}