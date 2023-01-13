resource "helm_release" "cilium" {
  depends_on = [
    module.k8s-yandex-cluster,
    helm_release.ycc
  ]
  name       = "cilium"
  repository = "https://helm.cilium.io"
  chart      = "cilium"
  version    = "1.12.0"
  namespace  = "kube-fraima-sdn"
  create_namespace  = true

  values = [
    templatefile("${path.module}/templates/helm/cilium/values.yaml.tftpl", {
      kube_apiserver_lb_fqdn  = module.k8s-yandex-cluster.kube-apiserver-lb
      kube_apiserver_port_lb  = module.k8s-yandex-cluster.k8s_global_vars.kubernetes-ports.kube-apiserver-port-lb
      service_cidr            = var.cidr.service
      k8s_api_server_fqdn     = module.k8s-yandex-cluster.k8s_global_vars.kube_apiserver_lb_fqdn
      k8s_api_server_port     = module.k8s-yandex-cluster.k8s_global_vars.kubernetes-ports.kube-apiserver-port-lb
      node_cidr_mask          = var.cidr.node_cidr_mask
      cluster_name            = var.cluster_name
      cluster_id              = 11
    })
  ]
  wait      = true
  atomic    = true
}
