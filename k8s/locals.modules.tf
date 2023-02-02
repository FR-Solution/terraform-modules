locals {
  global_vars         = module.k8s-yandex-cluster.k8s_global_vars
  kube_apiserver_ip   = module.k8s-yandex-cluster.kube-apiserver-lb
  kube_apiserver_port = module.k8s-yandex-cluster.k8s_global_vars.kubernetes-ports.kube-apiserver-port-lb
}
