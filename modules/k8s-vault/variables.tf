variable "k8s_certificate_vars" {
  description = "module:K8S-CERTIFICATE-VARS: base certificate vars"
  type        = any
  default     = {}
}

variable "cluster_name" {
  description = "K8S: cluster name"
  type        = string
  default     = null
}

variable "master_instance_count" {
  description = "K8S: masters number"
  type = number
  default = 0
}

variable "worker_instance_count" {
  description = "K8S: workers number"
  type = number
  default = 0
}
