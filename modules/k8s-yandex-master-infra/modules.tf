module "k8s-cloud-init-master" {
    source                          = "../k8s-templates/cloud-init-master"
    k8s_global_vars                 = var.k8s_global_vars
}   
