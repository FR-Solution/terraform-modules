variable "k8s_certificate_vars" {
  description = "module:K8S-CERTIFICATE-VARS: base certificate vars"
  type        = any
  default     = {}
}

variable "master_instance_list" {
  description = "module:K8S-CERTIFICATE-VARS: base certificate vars"
  type        = any
  default     = []
}

variable "worker_instance_list" {
  description = "module:K8S-CERTIFICATE-VARS: base certificate vars"
  type        = any
  default     = []
}

variable "cluster_name" {
  description = "K8S: cluster name"
  type        = string
  default     = null
}

variable "master-instance-count" {
  type = number
  default = 0
}

variable "worker-instance-count" {
  type = number
  default = 0
}