variable "k8s_global_vars" {
  type = any
  default = null
}

# variable "base_path" {
#   type = object({
#     static_pod_path = string
#     kubernetes_path = string
#   })
#   default = {
#     static_pod_path = "/etc/kubernetes/manifests"
#     kubernetes_path = "/etc/kubernetes"
#   }
# }

variable "actual-release" {
  type = string
  default = "v0_1"
}


variable "master_instance_list_map" {
  type        = any
  default     = {}
}

variable "master_instance_list" {
  type        = any
  default     = {}
}
