variable "k8s_global_vars" {
  description = "K8S: ?"
  type        = any
  default     = null
}


variable "kubernetes_version" {
  description = "K8S: ?"
  type        = string
  default     = null
}

variable "instance_type" {
  description = "K8S: node type"
  type        = string
  default     = null
}

variable "instance_list_map" {
  description = "K8S: instances"
  type        = any
  default     = {}
}


variable "etcd_advertise_client_urls" {
  description = "K8S: etcd_advertise_client_urls"
  type        = any
  default     = {}
}

variable "etcd_list_servers" {
  description = "K8S: etcd_list_servers"
  type        = any
  default     = {}
}
