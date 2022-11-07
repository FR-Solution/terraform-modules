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
