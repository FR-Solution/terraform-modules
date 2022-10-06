variable "etcd-image" {
  type = object({
    repository = string
    version = string

  })
  default = {
    repository = "k8s.gcr.io/etcd"
    version = "3.5.3-0"
  }
}

variable "kubernetes-version" {
  type = string
  default = "v1.23.10"

}

variable "kubernetes-version-major" {
  type = string
  default = "1.23"

}


variable "kube-apiserver-image" {
  type = string
  default = "k8s.gcr.io/kube-apiserver"

}

variable "kube-controller-manager-image" {
  type = string
  default = "k8s.gcr.io/kube-controller-manager"

}

variable "kube-scheduler-image" {
  type = string
  default = "k8s.gcr.io/kube-scheduler"

}