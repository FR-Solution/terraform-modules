module "static-pod-etcd" {
    source = "../static-pods/etcd"
    k8s_global_vars     = var.k8s_global_vars
    instance_list_map   = var.k8s_global_vars.master_vars.master_instance_extra_list_map
}

module "static-pod-kubeadm-config" {
    source = "../static-pods/kubeadm-config"
    k8s_global_vars             = var.k8s_global_vars
    instance_list_map           = var.k8s_global_vars.master_vars.master_instance_extra_list_map
    etcd_advertise_client_urls  = local.etcd_advertise_client_urls
    etcd_list_servers           = local.etcd_list_servers
}
