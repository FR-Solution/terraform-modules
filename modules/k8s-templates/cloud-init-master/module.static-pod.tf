module "static-pod-etcd" {
    source = "../static-pods/etcd"
    k8s_global_vars = var.k8s_global_vars
    etcd_image    = local.release-vars[var.actual-release].etcd.registry
    etcd_version  = local.release-vars[var.actual-release].etcd.version
    instance_list_map = var.master_instance_extra_list_map
}

module "static-pod-kubeadm-config" {
    source = "../static-pods/kubeadm-config"
    k8s_global_vars = var.k8s_global_vars
    kubernetes_version    = local.release-vars[var.actual-release].kubernetes.version
    instance_list_map = var.master_instance_extra_list_map
    etcd_advertise_client_urls = local.etcd_advertise_client_urls
    etcd_list_servers = local.etcd_list_servers
}
