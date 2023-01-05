variable "k8s_global_vars" {
  description = "module:K8S-CERTIFICATE-VARS: base certificate vars"
  type        = any
  default     = {}
}

variable "master_instance_list" {
  type        = any
  default     = null
}

variable "master_instance_list_map" {
  type        = any
  default     = null
}
