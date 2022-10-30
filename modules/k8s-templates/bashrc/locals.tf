locals {
  bashrc-k8s  = templatefile("${path.module}/templates/bashrc.tftpl", {
          ssl       = var.k8s_global_vars.ssl
          base_path = var.k8s_global_vars.global_path
    })
}
