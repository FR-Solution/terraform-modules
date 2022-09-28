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

variable "cluster_name" {
  type = string
  default = "default"
}

variable "base_domain" {
  type = string
  default = "dobry-kot.ru"
}


variable "master-configs" {
  type = object({
    group = string
  })
  default = {
    group = "master"

  }
}

variable "master-instance-count" {
  type = number
  default = 1
}

locals {
  master-instance-list = flatten([
    for master-index in range(var.master-instance-count): [
     "master-${master-index + 1}"
    ]
  ])
}


variable "etcd_server_port" {
  type = string
  default = "2379"
}

variable "kube_apiserver_port" {
  type = string
  default = "6443"
}

locals {
  list_masters                = formatlist("master-%s.${var.cluster_name}.${var.base_domain}", 
                                            range(length(var.availability_zones)))

  etcd_list_servers           = formatlist("https://master-%s.${var.cluster_name}.${var.base_domain}:2379", 
                                            range(length(var.availability_zones)))
  etcd_list_initial_cluster   = formatlist("master-%s.${var.cluster_name}.${var.base_domain}=https://master-%s.${var.cluster_name}.${var.base_domain}:2380", 
                                            range(length(var.availability_zones)), 
                                            range(length(var.availability_zones)))

  etcd_advertise_client_urls  = join(",", local.etcd_list_servers)
  etcd_initial_cluster        = join(",", local.etcd_list_initial_cluster)

  service_cidr                = "29.64.0.0/16"
  local_api_address           = format("%s.1", join(".", slice(split(".",local.service_cidr), 0, 3)) )
  dns_address                 = format("%s.10", join(".", slice(split(".",local.service_cidr), 0, 3)) )


  base_cluster_fqdn           = format("%s.%s"  , var.cluster_name, var.base_domain)
  etcd_server_lb_fqdn         = format("etcd.%s", local.base_cluster_fqdn)
  kube_apiserver_lb_fqdn      = format("api.%s" , local.base_cluster_fqdn)
  
  etcd_server_lb_access       = format("%s:%s" , local.etcd_server_lb_fqdn, var.etcd_server_port)
  kube_apiserver_lb_access    = format("%s:%s" , local.kube_apiserver_lb_fqdn, var.kube_apiserver_port)

  kubelet-config-args = {
    dns_address = local.dns_address
  }
}
