locals {
    kubelet-config                    = templatefile("${path.module}/templates/config.yaml.tftpl", {
        ssl                           = var.k8s_global_vars.ssl
        kubelet-config-args           = local.kubelet-config-args
        base_static_pod_path          = var.k8s_global_vars.global_path.base_static_pod_path
        instance_type                 = var.instance_type
    })
    kubelet-config-args = {
      dns_address = var.k8s_global_vars.k8s-addresses.dns_address
    }
}