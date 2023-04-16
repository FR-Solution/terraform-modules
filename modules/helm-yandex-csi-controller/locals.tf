locals {
  k8s_api_server      = var.global_vars.k8s-addresses.kube_apiserver_lb_fqdn
  k8s_api_server_port = var.global_vars.kubernetes-ports.kube-apiserver-port-lb

  base_values =  yamldecode(templatefile("${path.module}/helm/values.yaml.tftpl", {
    yandex_cloud_controller_sa  = local.yandex_k8s_csi_controller_sa_payload
    kubeApiServerIP             = "https://${local.k8s_api_server}:${local.k8s_api_server_port}"
  }))

  merge_values = merge(local.base_values, var.extra_values.extra_values)
}