variable "cluster_name" {
  description = "K8S: cluster name"
  type        = string
  default     = null
}

variable "service_cidr" {
  description = "K8S: cluster name"
  type        = string
  default     = "29.64.0.0/16"
}

variable "wildcard_base_cluster_fqdn" {
  description = "K8S: base wildcard domain"
  type        = string
  default     = null
}

variable "base_domain" {
  description = "K8S: base domain"
  type        = string
  default     = null
}

variable "kube_apiserver_lb_fqdn" {
  description = "K8S: kube-apiserver external fqdn"
  type        = string
  default     = null
}

variable "kube_apiserver_lb_fqdn_local" {
  description = "K8S: kube-apiserver internal fqdn"
  type        = string
  default     = null
}

variable "k8s_service_kube_apiserver_address" {
  description = "K8S: kube-apiserver internal service IP"
  type        = string
  default     = null
}

variable "base_local_path_certs" {
  description = "K8S: base path for kubernetes certs"
  type        = string
  default     = null
}

variable "base_local_path_vault" {
  description = "KEY-KEEPER: base path for key-keeper tokens"
  type        = string
  default     = null
}

variable "base_vault_path" {
  description = "VAULT: base path for vault pki"
  type        = string
  default     = null
}

variable "base_vault_path_kv" {
  description = "VAULT: base path for vault kv-store"
  type        = string
  default     = null
}

variable "base_vault_path_approle" {
  description = "VAULT: base path for vault approles"
  type        = string
  default     = null
}

variable "root_vault_path_pki" {
  description = "VAULT: base path for root vault pki"
  type        = string
  default     = null
}

variable "base_static_pod_path" {
  description = "K8S: base path for static pods"
  type        = string
  default     = null
}

variable "base_kubernetes_path" {
  description = "VAULT: base path for k8s"
  type        = string
  default     = null
}





variable "master_instance_count" {
  description = "K8S: masters number"
  type = number
  default = 0
}

variable "worker_instance_count" {
  description = "K8S: workers number"
  type = number
  default = 0
}



variable "vault_server" {
  type = string
  default = ""
}

variable "vault_server_insecure" {
  type = bool
  default = true
}

variable "caBundle" {
  type = string
  default = ""
}


variable "ssh_username" {
  description = "module:K8S "
  type        = string
  default     = "dkot"
}

variable "ssh_rsa_path" {
  description = "module:K8S "
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "pod_cidr" {
  type = string
  default = null
}

variable "node_cidr_mask" {
  type = string
  default = null
}