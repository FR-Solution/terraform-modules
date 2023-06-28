locals {
  bashrc-k8s  = templatefile("${path.module}/templates/bashrc.tftpl", {
          ssl               = var.k8s_global_vars.ssl
          base_path         = var.k8s_global_vars.global_path
          main_path         = var.k8s_global_vars.main_path
          etcd_server_port  = var.k8s_global_vars.kubernetes-ports.etcd-server-port
    })
}
