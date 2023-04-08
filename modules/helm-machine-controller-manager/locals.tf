locals {
  base_values =  try(yamldecode(templatefile("${path.module}/helm/values.yaml.tftpl", {
  })), {} )

  merge_values = merge(local.base_values, var.extra_values)
}