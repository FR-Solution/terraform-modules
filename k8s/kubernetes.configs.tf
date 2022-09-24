variable "base_path" {
  type = object({
    static_pod_path = string
    kubernetes_path = string
  })
  default = {
    static_pod_path = "/etc/kubernetes/manifests"
    kubernetes_path = "/etc/kubernetes"
  }
}

variable "master-configs" {
  type = object({
    group = string
  })
  default = {
    group = "master"

  }
}

locals {
  list_masters               = formatlist("master-%s.${var.cluster_name}.${var.base_domain}", 
                                            range(length(var.availability_zones)))

  etcd_list_servers          = formatlist("https://master-%s.${var.cluster_name}.${var.base_domain}:2379", 
                                            range(length(var.availability_zones)))
  etcd_list_initial_cluster  = formatlist("master-%s.${var.cluster_name}.${var.base_domain}=https://master-%s.${var.cluster_name}.${var.base_domain}:2380", 
                                            range(length(var.availability_zones)), 
                                            range(length(var.availability_zones)))

  etcd_advertise_client_urls = join(",", local.etcd_list_servers)
  etcd_initial_cluster       = join(",", local.etcd_list_initial_cluster)

  service_cidr  = "29.64.0.0/16"
  api_address   = format("%s.1", join(".", slice(split(".",local.service_cidr), 0, 3)) )
  dns_address   = format("%s.10", join(".", slice(split(".",local.service_cidr), 0, 3)) )
  
  kubelet-config-args = {
    dns_address = local.dns_address
  }
}
