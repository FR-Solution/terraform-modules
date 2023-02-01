output "LB-IP" {
    value = "kubectl config set-cluster  cluster --server=https://${module.k8s-yandex-cluster.kube-apiserver-lb} --insecure-skip-tls-verify"
}
