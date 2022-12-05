module "kubelet-service-master" {
    source = "../services/kubelet"
    instance_type = "master"
    k8s_global_vars = var.k8s_global_vars
    instance_list_map = var.master_instance_list_map
}

module "key-keeper-service-master" {
    source = "../services/key-keeper"
    instance_type = "master"
    k8s_global_vars = var.k8s_global_vars
    instance_list_map = var.master_instance_list_map
}
