locals {
    kubelet-config  = templatefile("${path.module}/templates/config.yaml.tftpl", {
        kubelet_config_flags  = var.k8s_global_vars.kube_flags.kubelet_config_flags
    })

}