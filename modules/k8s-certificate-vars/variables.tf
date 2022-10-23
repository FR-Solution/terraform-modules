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


