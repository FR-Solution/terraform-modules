

module "kubelet-bootstrap-kubeconfig" {
    source = "../kubeconfig"
      component-name        = "kubelet"
      certificate-authority = local.kubelet-bootstrap-kubeconfig-certificate-authority
      client-certificate    = local.kubelet-bootstrap-kubeconfig-client-certificate
      client-key            = local.kubelet-bootstrap-kubeconfig-client-key
      kube-apiserver-port   = var.k8s_global_vars.kubernetes-ports.kube-apiserver-port-lb
      kube-apiserver        = var.k8s_global_vars.k8s-addresses.kube_apiserver_lb_fqdn

}
