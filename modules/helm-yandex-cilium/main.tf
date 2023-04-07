module "cilium" {

  source = "../helm-temlate"

  release_name  = var.release_name
  chart_repo    = var.chart_repo
  chart_name    = var.chart_name
  chart_version = var.chart_version
  namespace     = var.namespace

  global_vars   = var.global_vars
  extra_values  = local.merge_values

}
