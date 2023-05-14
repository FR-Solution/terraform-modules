locals {
  default_kube_controller_manager_flags = {
    secure-port         = "${ local.kubernetes-ports.kube-controller-manager-port }"
    cluster-cidr        = "${ local.k8s_network.pod_cidr }"
    node-cidr-mask-size = "${ local.k8s_network.node_cidr_mask }"
    cluster-name        = "${ local.cluster_metadata.cluster_name}"
  }
}

data "utils_deep_merge_yaml" "kube_controller_manager_flags" {
  input = [
    yamlencode(local.default_kube_controller_manager_flags),
    file("default/kube-controller-manager.yaml"),
    yamlencode(try(var.extra_args.kube_controller_manager_flags, {}))
  ]
}
