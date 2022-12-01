variable "k8s_global_vars" {
  description = "K8S: ?"
  type        = any
  default     = null
}

variable "kube_scheduler_image" {
  description = "K8S: ?"
  type        = string
  default     = null
}

variable "kube_scheduler_version" {
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

