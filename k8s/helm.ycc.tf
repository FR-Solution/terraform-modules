module "k8s-yandex-cloud-controller" {
  source = "../modules/k8s-yandex-cloud-controller"

  yandex_default_vpc_name         = var.yandex_default_vpc_name
  yandex_default_route_table_name = var.yandex_default_route_table_name

  k8s_api_server      = module.k8s-yandex-cluster.kube-apiserver-lb
  k8s_api_server_port = module.k8s-yandex-cluster.k8s_global_vars.kubernetes-ports.kube-apiserver-port-lb

  pod_cidr      = var.cidr.pod

  cluster_name  = var.cluster_name

  chart_version = "0.0.3"

}