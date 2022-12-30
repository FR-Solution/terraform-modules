

variable "k8s_global_vars" {
  description = "module:K8S-CERTIFICATE-VARS: base certificate vars"
  type        = any
  default     = {}
}

variable "vault_policy_kubernetes_sign_approle" {
  type     = any
  default  = {}
}

variable "cloud_metadata" {
  type = object({
    folder_id = string
  })
  default = {
    folder_id = null
    }
}

variable "master_group"{
  type = object({
    name = string
    count = number
    vpc_id = string
    subnets  = any
    default_zone = string
    resources_overwrite = any
    resources = any
    metadata = any
  })
  default = {
    name = "master"
    count = 0
    vpc_id = null
    subnets = null
    default_zone = "ru-central1-a"
    resources_overwrite = {}
    metadata = {}
    resources = {
      core = 4
      memory = 8
      core_fraction = 100
      disk = {}
    }
  }
}
