
variable "component-name" {
  description = "K8S: component name"
  type        = string
  default     = "default"
}

variable "certificate-authority" {
  description = "K8S: cluster ca bundle path"
  type        = string
  default     = null
}

variable "kube-apiserver" {
  description = "K8S: cluster api"
  type        = string
  default     = "127.0.0.1"
}

variable "kube-apiserver-port" {
  description = "K8S: cluster api port"
  type        = string
  default     = "443"
}

variable "client-certificate" {
  description = "K8S: cluster client cert path"
  type        = string
  default     = null
}

variable "client-key" {
  description = "K8S: cluster client cert key path "
  type        = string
  default     = null
}
