resource "helm_release" "cilium" {
  depends_on = [module.k8s-infrastructure]
  name       = "cilium"
  repository = "https://helm.cilium.io"
  chart      = "cilium"
  version    = "1.12.0"
  namespace  = "fraima-cni"
  create_namespace  = true

  values = [
    templatefile("${path.module}/templates/helm/cilium/values.yaml.tftpl", {
      kube_apiserver_lb_fqdn = local.lb-kube-apiserver-ip
    })
  ]
}
