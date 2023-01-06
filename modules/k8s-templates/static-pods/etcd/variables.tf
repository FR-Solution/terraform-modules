variable "k8s_global_vars" {
  description = "K8S: ?"
  type        = any
  default     = null
}

variable "data_dir" {
  description = "K8S: ?"
  type        = string
  default     = "/var/lib/etcd"
}

variable "etcd_version" {
  description = "K8S: ?"
  type        = string
  default     = null
}

variable "etcd_image" {
  description = "K8S: ?"
  type        = string
  default     = null
}

variable "instance_list_map" {
  description = "K8S: node type"
  type        = any
  default     = {}
}
