locals {
  kubernetes-ports = {
    etcd-server-port-lb         = "43379"
    etcd-server-port-target-lb  = "2382"
    etcd-server-port            = "2379"
    etcd-peer-port              = "2380"
    etcd-metrics-port           = "2381"
    kube-apiserver-port         = "443"
    kube-apiserver-port-lb      = "6443"
  }
}
