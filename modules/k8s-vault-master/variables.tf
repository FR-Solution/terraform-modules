variable "k8s_global_vars" {
  description = "module:K8S-CERTIFICATE-VARS: base certificate vars"
  type        = any
  default     = {}
}

variable "master_instance_list_map" {
  type        = any
  default     = null
}

variable "vault_approle_auth_backend_role_secret_id" {
  type = object({
    enabled = bool
  })
  default = {
    enabled = true
  }
}
