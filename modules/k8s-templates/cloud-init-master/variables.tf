variable "k8s_global_vars" {
  type = any
  default = null
}

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

variable "master_instance_extra_list_map" {
  type        = any
  default     = {}
}

variable "master_instance_extra_list" {
  type        = any
  default     = {}
}

variable "node_group_metadata" {
  type        = any
  default     = {}
}
