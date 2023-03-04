locals {
  kube_flags = {
    kube_apiserver_flags          = yamlencode(merge(local.default_kube_apiserver_flags,          try(var.extra_args.kube_apiserver_flags,           {})))
    kube_controller_manager_flags = yamlencode(merge(local.default_kube_controller_manager_flags, try(var.extra_args.kube_controller_manager_flags,  {})))
    kube_scheduler_flags          = yamlencode(merge(local.default_kube_scheduler_flags,          try(var.extra_args.kube_scheduler_flags,           {})))
    kubelet_config_flags          = yamlencode(merge(local.default_kubelet_config_flags,          try(var.extra_args.kubelet_config_flags,           {})))
  }
}
