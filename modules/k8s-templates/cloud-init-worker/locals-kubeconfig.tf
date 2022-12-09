
locals {
  kubernetes-ca-ssl                                         = var.k8s_global_vars.ssl.intermediate["kubernetes-ca"]
  
  kubelet-bootstrap-kubeconfig-certificate-authority        = "${local.kubernetes-ca-ssl.host_path}/kubernetes-ca.pem"
  kubelet-bootstrap-kubeconfig-client-certificate           = "${local.kubernetes-ca-ssl.issuers["bootstrappers-client"].certificates["bootstrappers-client"].key-keeper-args.host_path}/bootstrappers-client.pem"
  kubelet-bootstrap-kubeconfig-client-key                   = "${local.kubernetes-ca-ssl.issuers["bootstrappers-client"].certificates["bootstrappers-client"].key-keeper-args.host_path}/bootstrappers-client-key.pem"
}
