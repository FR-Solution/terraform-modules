module "k8s-yandex-cloud-controller" {
  source = "../modules/helm-yandex-cloud-controller"

  chart_version = "0.0.3"

  yandex_default_vpc_name         = local.master_group_merge.vpc_name
  yandex_default_route_table_name = local.master_group_merge.route_table_name

  global_vars         = local.global_vars
  
  extra_values        = {} 
}
