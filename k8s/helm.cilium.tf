resource "helm_release" "cilium" {
  depends_on = [module.k8s-control-plane]
  name       = "cilium"
  repository = "https://helm.cilium.io"
  chart      = "cilium"
  version    = "1.12.0"
  namespace  = "fraima-cni"
  create_namespace  = true

  values = [
    templatefile("${path.module}/templates/helm/cilium/values.yaml.tftpl", {
      kube_apiserver_lb_fqdn = module.k8s-global-vars.k8s-addresses.kube_apiserver_lb_fqdn
      kube_apiserver_port_lb = module.k8s-global-vars.kubernetes-ports.kube-apiserver-port-lb
    })
  ]
}
