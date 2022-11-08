
variable "hostname" {
  type = string
  default = null
}


variable "cluster_name" {
  type = string
  default = "default"
}

variable "base_domain" {
  type = string
  default = "dobry-kot.ru"
}

variable "etcd-data-base-dir" {
  type = string
  default = "/var/lib/etcd"
}

variable "vault_bootstrap_token_all" {
  type = string
  default = null
}

variable "k8s_global_vars" {
  type = any
  default = null
}

variable "base_local_path_certs" {
  type = string
  default = null
}


variable "kube-apiserver-lb-fqdn" {
  type = string
  default = null
}

variable "vault-bootstrap-master-token" {
  type = any
  default = null
}

variable "vault-bootstrap-worker-token" {
  type = any
  default = null
}



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

variable "master_instance_list_map" {
  type = any
  default = null
}

variable "worker_instance_list_map" {
  type = any
  default = null
}


variable "etcd-server-port-lb" {
  type = string
  default = "43379"
}

variable "kube-apiserver-port-lb" {
  type = string
  default = "6443"
}

variable "etcd-server-port-target-lb" {
  type = string
  default = "2382"
}

variable "etcd-server-port" {
  type = string
  default = "2379"
}

variable "etcd-peer-port" {
  type = string
  default = "2380"
}

variable "etcd-metrics-port" {
  type = string
  default = "2381"
}

variable "kube-apiserver-port" {
  type = string
  default = "443"
}


variable "kubernetes-version" {
  type = string
  default = "v1.22.7"

}

variable "kubernetes-version-major" {
  type = string
  default = "1.22"

}

variable "actual-release" {
  type = string
  default = "v0_1"
}
