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
    zone = string
  })
  default = {
    group = "master"
    zone  = "ru-central1-a"

  }
}

variable "worker-configs" {
  type = object({
    group = string
    zone = string
  })
  default = {
    group = "master"
    zone  = "ru-central1-a"

  }
}

variable "etcd-data-base-dir" {
  type = string
  default = "/var/lib/etcd"
}


locals {
  list_masters                  = formatlist("master-%s.${var.cluster_name}.${var.base_domain}", 
                                            range(var.master-instance-count))

  etcd_list_servers             = formatlist("https://master-%s.${var.cluster_name}.${var.base_domain}:${var.etcd-server-port}", 
                                            range(var.master-instance-count))
  etcd_list_initial_cluster     = formatlist("master-%s.${var.cluster_name}.${var.base_domain}=https://master-%s.${var.cluster_name}.${var.base_domain}:${var.etcd-peer-port}", 
                                            range(var.master-instance-count), 
                                            range(var.master-instance-count))

  etcd_advertise_client_urls    = join(",", local.etcd_list_servers)
  etcd_initial_cluster          = join(",", local.etcd_list_initial_cluster)

  service_cidr                  = "29.64.0.0/16"
  local_api_address             = format("%s.1", join(".", slice(split(".",local.service_cidr), 0, 3)) )
  dns_address                   = format("%s.10", join(".", slice(split(".",local.service_cidr), 0, 3)) )

  idp_provider_fqdn             = format("auth.%s", var.base_domain)
  base_cluster_fqdn             = format("%s.%s"  , var.cluster_name, var.base_domain)
  wildcard_base_cluster_fqdn    = format("%s.%s", "*"       , local.base_cluster_fqdn)
  etcd_server_lb_fqdn           = format("%s.%s", "etcd"    , local.base_cluster_fqdn)
  kube_apiserver_lb_fqdn        = format("%s.%s", "api"     , local.base_cluster_fqdn)
  kube_apiserver_lb_fqdn_local  = format("%s.%s", "api-int" , local.base_cluster_fqdn)
  
  etcd_server_lb_access         = format("%s:%s" , local.etcd_server_lb_fqdn, var.etcd-server-port-lb)
  kube_apiserver_lb_access      = format("%s:%s" , local.kube_apiserver_lb_fqdn, var.kube-apiserver-port-lb)

  master_instance_list        = flatten([
    for master-index in range(var.master-instance-count): [
     "master-${master-index}"
    ]
  ])

  master_instance_list_map = { for item in local.master_instance_list :
    item => {}
  }


  worker_instance_list        = flatten([
    for worker-index in range(var.worker-instance-count): [
     "worker-${worker-index}"
    ]
  ])

  worker_instance_list_map = { for item in local.worker_instance_list :
    item => {}
  }

  kubelet-config-args = {
    dns_address = local.dns_address
  }
}
