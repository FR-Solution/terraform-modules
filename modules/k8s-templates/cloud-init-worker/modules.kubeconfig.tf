module "kube-apiserver-admin-kubeconfig" {
    source = "../kubeconfig"
      component-name        = "kube-apiserver"
      certificate-authority = local.kube-apiserver-admin-kubeconfig-certificate-authority
      client-certificate    = local.kube-apiserver-admin-kubeconfig-client-certificate
      client-key            = local.kube-apiserver-admin-kubeconfig-client-key
      kube-apiserver-port   = var.k8s_global_vars.kubernetes-ports.kube-apiserver-port
}

module "kubelet-kubeconfig" {
    source = "../kubeconfig"
      component-name        = "kubelet"
      certificate-authority = local.kubelet-kubeconfig-certificate-authority
      client-certificate    = local.kubelet-kubeconfig-client-certificate
      client-key            = local.kubelet-kubeconfig-client-key
      kube-apiserver-port   = var.k8s_global_vars.kubernetes-ports.kube-apiserver-port
}

module "kubelet-bootstrap-kubeconfig" {
    source = "../kubeconfig"
      component-name        = "kubelet"
      certificate-authority = local.kubelet-bootstrap-kubeconfig-certificate-authority
      client-certificate    = local.kubelet-bootstrap-kubeconfig-client-certificate
      client-key            = local.kubelet-bootstrap-kubeconfig-client-key
      kube-apiserver-port   = var.k8s_global_vars.kubernetes-ports.kube-apiserver-port-lb
      kube-apiserver        = var.k8s_global_vars.k8s-addresses.kube_apiserver_lb_fqdn

}

module "kube-scheduler-kubeconfig" {
    source = "../kubeconfig"
      component-name        = "kube-scheduler"
      certificate-authority = local.kube-scheduler-kubeconfig-certificate-authority
      client-certificate    = local.kube-scheduler-kubeconfig-client-certificate
      client-key            = local.kube-scheduler-kubeconfig-client-key
      kube-apiserver-port   = var.k8s_global_vars.kubernetes-ports.kube-apiserver-port
}

module "kube-controller-manager-kubeconfig" {
    source = "../kubeconfig"
      component-name        = "kube-controller-manager"
      certificate-authority = local.kube-controller-manager-kubeconfig-certificate-authority
      client-certificate    = local.kube-controller-manager-kubeconfig-client-certificate
      client-key            = local.kube-controller-manager-kubeconfig-client-key
      kube-apiserver-port   = var.k8s_global_vars.kubernetes-ports.kube-apiserver-port
}