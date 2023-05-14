locals {
  kube_flags = {
    kube_apiserver_flags          = data.utils_deep_merge_yaml.kube_apiserver_flags
    kube_controller_manager_flags = data.utils_deep_merge_yaml.kube_controller_manager_flags
    kube_scheduler_flags          = data.utils_deep_merge_yaml.kube_scheduler_flags
    kubelet_config_flags          = data.utils_deep_merge_yaml.kubelet_config_flags
  }
}