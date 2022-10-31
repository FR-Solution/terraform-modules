

variable "k8s_global_vars" {
  description = "module:K8S-CERTIFICATE-VARS: base certificate vars"
  type        = any
  default     = {}
}


variable "cloud_init_template" {
  description = "module:K8S "
  type        = any
  default     = {}
}

variable "master-configs" {
  type     = any
  default  = {}
}
