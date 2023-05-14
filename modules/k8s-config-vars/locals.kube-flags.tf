locals {
  kube_flags = {
    kube_apiserver_flags          = yamlencode(data.utils_deep_merge_yaml.kube_apiserver_flags.output)
    kube_controller_manager_flags = yamlencode(data.utils_deep_merge_yaml.kube_controller_manager_flags.output)
    kube_scheduler_flags          = yamlencode(data.utils_deep_merge_yaml.kube_scheduler_flags.output)
    kubelet_config_flags          = yamlencode(data.utils_deep_merge_yaml.kubelet_config_flags.output)
  }
}