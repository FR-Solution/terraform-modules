

# variable "worker_instance_count" {
#   type     = number
#   default  = 0
# }

# variable "worker_instance_name" {
#   type     = string
#   default  = "default"
# }

variable "k8s_global_vars" {
  description = "module:K8S-CERTIFICATE-VARS: base certificate vars"
  type        = any
  default     = {}
}

variable "worker_instance_list" {
  type        = any
  default     = null
}

variable "worker_instance_list_map" {
  type        = any
  default     = null
}

