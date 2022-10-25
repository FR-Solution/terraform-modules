module "k8s-global-vars" {
    source = "github.com/fraima/kubernetes//modules/k8s-certificate-vars?ref=FR-16"
    cluster_name    = var.cluster_name
    base_domain     = "dobry-kot.ru"
    # service_cidr    = "10.100.0.0/24"
}

module "k8s-vault" {
    source = "github.com/fraima/kubernetes//modules/k8s-vault?ref=FR-16"
    k8s_global_vars  = module.k8s-global-vars
    master_instance_count = var.master-instance-count
    worker_instance_count = var.worker-instance-count
    cluster_name          = var.cluster_name

}
