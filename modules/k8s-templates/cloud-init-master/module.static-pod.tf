module "static-pod-etcd" {
    source = "../static-pods/etcd"
    instance_type = "master"
    k8s_global_vars = var.k8s_global_vars
    etcd_image    = local.release-vars[var.actual-release].etcd.registry
    etcd_version  = local.release-vars[var.actual-release].etcd.version
    instance_list_map = var.master_instance_list_map
}

module "static-pod-kube-apiserver" {
    source = "../static-pods/kube-apiserver"
    instance_type = "master"
    k8s_global_vars = var.k8s_global_vars
    kube_apiserver_image          = local.release-vars[var.actual-release].kube-apiserver.registry
    kube_apiserver_image_version  = local.release-vars[var.actual-release].kube-apiserver.version
    oidc_issuer_url = "https://auth.dobry-kot.ru/auth"
    oidc_client_id  = "kubernetes-master"
    instance_list_map = var.master_instance_list_map
    etcd_advertise_client_urls = local.etcd_advertise_client_urls
}

# module "static-pod-kube-controller-manager" {
#     source = "../static-pods/kube-controller-manager"
#     instance_type = "master"
#     k8s_global_vars = var.k8s_global_vars
#     kube_controller_manager_image    = local.release-vars[var.actual-release].kube-controller-manager.registry
#     kube_controller_manager_version  = local.release-vars[var.actual-release].kube-controller-manager.version
#     instance_list_map = var.master_instance_list_map
# }

# module "static-pod-kube-scheduler" {
#     source = "../static-pods/kube-scheduler"
#     instance_type = "master"
#     k8s_global_vars = var.k8s_global_vars
#     kube_scheduler_image    = local.release-vars[var.actual-release].kube-scheduler.registry
#     kube_scheduler_version  = local.release-vars[var.actual-release].kube-scheduler.version
#     instance_list_map = var.master_instance_list_map

# }

module "static-pod-kubeadm-config" {
    source = "../static-pods/kubeadm-config"
    instance_type = "master"
    k8s_global_vars = var.k8s_global_vars
    kubernetes_version    = local.release-vars[var.actual-release].kubernetes.version
    instance_list_map = var.master_instance_list_map
    etcd_advertise_client_urls = local.etcd_advertise_client_urls
    etcd_list_servers = local.etcd_list_servers
}
