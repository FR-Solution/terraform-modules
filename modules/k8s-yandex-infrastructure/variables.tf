

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

variable "yandex_cloud_name" {
  description = "module:K8S "
  type        = string
  default     = null
}

variable "yandex_folder_name" {
  description = "module:K8S "
  type        = string
  default     = null
}

variable "master-configs" {
  type     = any
  default  = {}
}
