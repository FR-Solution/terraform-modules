
variable "master-instance-count" {
  type = number
  default = 3
}

variable "worker-instance-count" {
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
    master-instance-count = var.master-instance-count
    worker-instance-count = var.worker-instance-count
    cluster_name          = "treska"

}
