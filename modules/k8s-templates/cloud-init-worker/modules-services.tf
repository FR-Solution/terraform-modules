module "kubelet-service-worker" {
    source = "../services/kubelet"
    instance_type = "worker"
    k8s_global_vars = var.k8s_global_vars
    instance_list_map = var.worker_instance_list_map
}

module "key-keeper-service-worker" {
    source = "../services/key-keeper"
    instance_type = "worker"
    k8s_global_vars = var.k8s_global_vars
    instance_list_map = var.worker_instance_list_map
}
