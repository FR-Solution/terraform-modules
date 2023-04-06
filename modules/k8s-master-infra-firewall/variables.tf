variable "k8s_global_vars" {
  description = "module:K8S-CERTIFICATE-VARS: base certificate vars"
  type        = any
  default     = {}
}

variable "cluster_instances" {
    type        = any
}

variable "cluster_api_ip" {
    type        = any
}
