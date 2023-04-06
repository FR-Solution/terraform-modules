variable "k8s_global_vars" {
  description = "module:K8S-CERTIFICATE-VARS: base certificate vars"
  type        = any
  default     = {}
}

variable "cluster_instances_internal" {
    type        = any
}

variable "cluster_instances_external" {
    type        = any
}

variable "cluster_api_ip" {
    type        = any
}
