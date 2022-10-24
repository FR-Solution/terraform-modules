
variable "etcd-server-port-lb" {
  type = string
  default = "43379"
}

variable "kube-apiserver-port-lb" {
  type = string
  default = "6443"
}

variable "etcd-server-port-target-lb" {
  type = string
  default = "2382"
}

variable "etcd-server-port" {
  type = string
  default = "2379"
}

variable "etcd-peer-port" {
  type = string
  default = "2380"
}

variable "etcd-metrics-port" {
  type = string
  default = "2381"
}

variable "kube-apiserver-port" {
  type = string
  default = "443"
}
