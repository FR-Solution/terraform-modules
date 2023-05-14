locals {
  kubernetes-ports = {
    etcd-server-port-target-lb    = "2382"
    etcd-server-port              = "2379"
    etcd-peer-port                = "2380"
    etcd-metrics-port             = "2381"
    kube-apiserver-port           = "6443"
    kube-apiserver-port-lb        = "443"
    kube-controller-manager-port  = "10257"
    kube-scheduler-port           = "10259"
    kubelet-healthz-port          = "10248"
  }
}
