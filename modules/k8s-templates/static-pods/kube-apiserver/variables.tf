variable "k8s_global_vars" {
  description = "K8S: ?"
  type        = any
  default     = null
}

variable "oidc_client_id" {
  description = "K8S: ?"
  type        = string
  default     = null
}

variable "oidc_issuer_url" {
  description = "K8S: ?"
  type        = string
  default     = null
}

variable "kube_apiserver_image_version" {
  description = "K8S: ?"
  type        = string
  default     = null
}

variable "kube_apiserver_image" {
  description = "K8S: ?"
  type        = string
  default     = null
}

variable "instance_list_map" {
  description = "K8S: node type"
  type        = any
  default     = {}
}

variable "etcd_advertise_client_urls" {
  description = "K8S: etcd_advertise_client_urls"
  type        = any
  default     = {}
}
