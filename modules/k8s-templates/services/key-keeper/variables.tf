

variable "instance_type" {
  description = "K8S: node type"
  type        = string
  default     = null
}

variable "cluster_name" {
  description = "K8S: cluster_name"
  type        = string
  default     = null
}

variable "k8s_global_vars" {
  description = "module:K8S-CERTIFICATE-VARS: base certificate vars"
  type        = any
  default     = {}
}
