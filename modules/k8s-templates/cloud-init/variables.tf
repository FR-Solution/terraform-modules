


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

variable "ssh_key_path" {
  type = string
  default = "~/.ssh/id_rsa.pub"
}

variable "ssh_user" {
  type = string
  default = null
}

variable "vault_bootstrap_token_all" {
  type = string
  default = null
}

variable "k8s_certificate_vars" {
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

# key-keeper-service
# key_keeper_config

# kubelet-service
# kubelet-service-args
# kubelet-config
# kubelet-service-d-fraima

# containerd-service

# base-cni

# sysctl-network

# modules-load-k8s

# etcd-manifest
# kube-apiserver-manifest
# kube-controller-manager-manifest
# kube-scheduler-manifest

# kube-apiserver-kubeconfig
# kube-controller-manager-kubeconfig
# kube-scheduler-kubeconfig
# kubelet-kubeconfig