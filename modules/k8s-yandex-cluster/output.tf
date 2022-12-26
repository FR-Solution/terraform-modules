output "k8s_global_vars" {
  value = module.k8s-global-vars
}

output "kube-apiserver-lb" {
  value = module.k8s-yandex-master-infra.kube-apiserver-lb
}

output "kube-apiserver-lb-fqdn" {
  value = module.k8s-global-vars.kube_apiserver_lb_fqdn
}

output "master_sa_policy" {
  value = module.k8s-yandex-master-infra.master_sa_policy
}