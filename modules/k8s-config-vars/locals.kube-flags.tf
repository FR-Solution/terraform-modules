locals {
  kube_flags = {
    kube_apiserver_flags          = yamlencode(data.utils_deep_merge_yaml.kube_apiserver_flags)
    kube_controller_manager_flags = yamlencode(data.utils_deep_merge_yaml.kube_controller_manager_flags)
    kube_scheduler_flags          = yamlencode(data.utils_deep_merge_yaml.kube_scheduler_flags)
    kubelet_config_flags          = yamlencode(data.utils_deep_merge_yaml.kubelet_config_flags)
  }
}