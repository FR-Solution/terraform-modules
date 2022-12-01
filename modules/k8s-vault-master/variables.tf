variable "k8s_global_vars" {
  description = "module:K8S-CERTIFICATE-VARS: base certificate vars"
  type        = any
  default     = {}
}

variable "master_instance_list" {
  type        = any
  default     = null
}

variable "vault_policy_kubernetes_sign_approle" {
  description = "module:VAULT: policy for cert roles"
  type        = any
  default     = {}
}

