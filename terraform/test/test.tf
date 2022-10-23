
variable "master_instance_count" {
  type = number
  default = 0
}

variable "worker_instance_count" {
  type = number
  default = 0
}

module "certificate-vars" {
    source = "../../modules/k8s-certificate-vars"
    cluster_name    = "treska"
    base_domain     = "dobry-kot.ru"
    service_cidr    = "10.100.0.0/24"
}

module "k8s-vault" {
    source = "../../modules/k8s-vault"
    k8s_certificate_vars  = module.certificate-vars
    master_instance_count = var.master_instance_count
    worker_instance_count = var.worker_instance_count
    cluster_name          = "osetr"

}

# module "k8s-master-cloud-init" {
#     source = "../../modules/k8s-vault"
# }

# module "k8s-worker-cloud-init" {
#     source = "../../modules/k8s-vault"
# }


# module "k8s-control-plane" {
#     source = "../../modules/k8s-vault"
# }

# module "k8s-helm" {
#     source = "../../modules/k8s-vault"
# }

# module "k8s-workers" {
#     source = "../../modules/k8s-vault"
# }

