variable "cluster_name" {
  description = "K8S: ?"
  type        = string
  default     = null
}

variable "base_domain" {
  description = "K8S: ?"
  type        = string
  default     = null
}

variable "full_instance_name" {
  description = "K8S: ?"
  type        = string
  default     = null
}

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

variable "etcd_peer_port" {
  description = "K8S: ?"
  type        = string
  default     = null
}

variable "etcd_server_port" {
  description = "K8S: ?"
  type        = string
  default     = null
}
variable "etcd_metrics_port" {
  description = "K8S: ?"
  type        = string
  default     = null
}
variable "etcd_server_port_target_lb" {
  description = "K8S: ?"
  type        = string
  default     = null
}

variable "base_local_path_certs" {
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
  description = "K8S: node type"
  type        = any
  default     = {}
}
