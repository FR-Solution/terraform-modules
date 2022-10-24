locals {
    kube-apiserver-manifest = templatefile("${path.module}/templates/kubeconfig.tftpl", {
        component-name          = var.component-name
        certificate-authority   = var.certificate-authority
        kube-apiserver          = var.kube-apiserver
        kube-apiserver-port     = var.kube-apiserver-port
        client-certificate      = var.client-certificate
        client-key              = var.client-key
    })

}
