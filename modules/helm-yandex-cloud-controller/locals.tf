locals {
  k8s_api_server      = var.global_vars.k8s-addresses.kube_apiserver_lb_fqdn
  k8s_api_server_port = var.global_vars.kubernetes-ports.kube-apiserver-port-lb
  pod_cidr            = var.global_vars.k8s_network.pod_cidr
  cluster_name        = var.global_vars.cluster_metadata.cluster_name

  base_values =  yamldecode(templatefile("${path.module}/helm/values.yaml.tftpl", {
    yandex_cloud_controller_sa  = local.yandex_k8s_controllers_sa_payload
    cluster_name                = local.cluster_name
    pod_cidr                    = local.pod_cidr
    k8s_api_server              = local.k8s_api_server
    k8s_api_server_port         = local.k8s_api_server_port
  }))

  merge_values = merge(local.base_values, var.extra_values)
}