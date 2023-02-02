module "k8s-yandex-cloud-controller" {
  source = "../modules/k8s-yandex-cloud-controller"

  yandex_default_vpc_name         = var.yandex_default_vpc_name
  yandex_default_route_table_name = var.yandex_default_route_table_name

  k8s_api_server      = module.k8s-yandex-cluster.kube-apiserver-lb
  global_vars         = module.k8s-yandex-cluster.k8s_global_vars

  chart_version = "0.0.3"

}