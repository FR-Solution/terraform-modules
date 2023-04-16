module "yandex-csi-controller" {

  source = "../helm-temlate"

  release_name  = try(var.extra_values.release.release_name   ,var.release_name)
  chart_repo    = try(var.extra_values.release.chart_repo     ,var.chart_repo)
  chart_name    = try(var.extra_values.release.chart_name     ,var.chart_name)
  chart_version = try(var.extra_values.release.chart_version  ,var.chart_version)
  namespace     = try(var.extra_values.release.namespace      ,var.namespace)

  global_vars   = var.global_vars
  extra_values  = local.merge_values

}
