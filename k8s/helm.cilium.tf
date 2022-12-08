resource "helm_release" "cilium" {
  depends_on = [module.k8s-yandex-cluster]
  name       = "cilium"
  repository = "https://helm.cilium.io"
  chart      = "cilium"
  version    = "1.12.0"
  namespace  = "fraima-cni"
  create_namespace  = true

  values = [
    templatefile("${path.module}/templates/helm/cilium/values.yaml.tftpl", {
      kube_apiserver_lb_fqdn = module.k8s-yandex-cluster.kube-apiserver-lb
      kube_apiserver_port_lb = module.k8s-yandex-cluster.k8s_global_vars.kubernetes-ports.kube-apiserver-port-lb
    })
  ]
}
