
locals {
  kubernetes-ca-ssl                                         = var.k8s_global_vars.ssl.intermediate["kubernetes-ca"]

  kube-apiserver-admin-kubeconfig-certificate-authority     = "${local.kubernetes-ca-ssl.default.host_path}/kubernetes-ca.pem"
  kube-apiserver-admin-kubeconfig-client-certificate        = "${local.kubernetes-ca-ssl.issuers["kubeadm-client"].certificates["kubeadm-client"].key-keeper-args.host_path}/kubeadm-client.pem"
  kube-apiserver-admin-kubeconfig-client-key                = "${local.kubernetes-ca-ssl.issuers["kubeadm-client"].certificates["kubeadm-client"].key-keeper-args.host_path}/kubeadm-client-key.pem"

  kubelet-bootstrap-kubeconfig-certificate-authority        = "${local.kubernetes-ca-ssl.default.host_path}/kubernetes-ca.pem"
  kubelet-bootstrap-kubeconfig-client-certificate           = "${local.kubernetes-ca-ssl.issuers["bootstrappers-client"].certificates["bootstrappers-client"].key-keeper-args.host_path}/bootstrappers-client.pem"
  kubelet-bootstrap-kubeconfig-client-key                   = "${local.kubernetes-ca-ssl.issuers["bootstrappers-client"].certificates["bootstrappers-client"].key-keeper-args.host_path}/bootstrappers-client-key.pem"

  kubelet-kubeconfig-certificate-authority                  = "${local.kubernetes-ca-ssl.default.host_path}/kubernetes-ca.pem"
  kubelet-kubeconfig-client-certificate                     = "${local.kubernetes-ca-ssl.issuers["kubelet-client"].certificates["kubelet-client"].key-keeper-args.host_path}/kubelet-client.pem"
  kubelet-kubeconfig-client-key                             = "${local.kubernetes-ca-ssl.issuers["kubelet-client"].certificates["kubelet-client"].key-keeper-args.host_path}/kubelet-client-key.pem"

  kube-scheduler-kubeconfig-certificate-authority           = "${local.kubernetes-ca-ssl.default.host_path}/kubernetes-ca.pem"
  kube-scheduler-kubeconfig-client-certificate              = "${local.kubernetes-ca-ssl.issuers["kube-scheduler-client"].certificates["kube-scheduler-client"].key-keeper-args.host_path}/kube-scheduler-client.pem"
  kube-scheduler-kubeconfig-client-key                      = "${local.kubernetes-ca-ssl.issuers["kube-scheduler-client"].certificates["kube-scheduler-client"].key-keeper-args.host_path}/kube-scheduler-client-key.pem"

  kube-controller-manager-kubeconfig-certificate-authority  = "${local.kubernetes-ca-ssl.default.host_path}/kubernetes-ca.pem"
  kube-controller-manager-kubeconfig-client-certificate     = "${local.kubernetes-ca-ssl.issuers["kube-controller-manager-client"].certificates["kube-controller-manager-client"].key-keeper-args.host_path}/kube-controller-manager-client.pem"
  kube-controller-manager-kubeconfig-client-key             = "${local.kubernetes-ca-ssl.issuers["kube-controller-manager-client"].certificates["kube-controller-manager-client"].key-keeper-args.host_path}/kube-controller-manager-client-key.pem"
}
