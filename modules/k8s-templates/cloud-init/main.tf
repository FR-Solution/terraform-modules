locals {
  cloud-init-template = flatten([
    for master_name, master_content in  var.master_instance_list_map:
      {"${master_name}" = templatefile("${path.module}/templates/cloud-init-test.tftpl", {

        ssh_key                           = file(var.ssh_key_path)
        base_local_path_certs             = var.k8s_certificate_vars.base_local_path_certs
        ssl                               = var.k8s_certificate_vars.ssl
        base_path                         = var.base_path
        hostname                          = "${master_name}-${var.cluster_name}"
        actual_release                    = var.actual-release
        release_vars                      = local.release-vars
        kube_apiserver_lb_fqdn            = var.kube-apiserver-lb-fqdn
        kube_apiserver_port_lb            = var.kube-apiserver-port-lb
        bootstrap_token_all               = var.vault-bootstrap-master-token[master_name].client_token

        kube-apiserver-kubeconfig           = module.kube-apiserver-kubeconfig.kubeconfig
        kubelet-kubeconfig                  = module.kubelet-kubeconfig.kubeconfig
        kube-scheduler-kubeconfig           = module.kube-scheduler-kubeconfig.kubeconfig
        kube-controller-manager-kubeconfig  = module.kube-controller-manager-kubeconfig.kubeconfig
      })}
    ])
  }

resource "vault_kv_secret_v2" "kube_apiserver_sa" {
  mount = "clusters/treska/kv/"
  name                       = "cloud-init"
  cas                        = 1
  delete_all_versions        = true
  data_json = jsonencode(
    {
      private = local.cloud-init-template 
    }
  )
}


locals {
  kubernetes-ca-ssl                                         = var.k8s_certificate_vars.ssl.intermediate["kubernetes-ca"]
  kube-apiserver-kubeconfig-certificate-authority           = "${local.kubernetes-ca-ssl.host_path}/kubernetes-ca.pem"
  kube-apiserver-kubeconfig-client-certificate              = "${local.kubernetes-ca-ssl.issuers["kube-apiserver-kubelet-client"].certificates["kube-apiserver-kubelet-client"].key-keeper-args.host_path}/kube-apiserver-kubelet-client.pem"
  kube-apiserver-kubeconfig-client-key                      = "${local.kubernetes-ca-ssl.issuers["kube-apiserver-kubelet-client"].certificates["kube-apiserver-kubelet-client"].key-keeper-args.host_path}/kube-apiserver-kubelet-client-key.pem"

  kubelet-kubeconfig-certificate-authority                  = "${local.kubernetes-ca-ssl.host_path}/kubernetes-ca.pem"
  kubelet-kubeconfig-client-certificate                     = "${local.kubernetes-ca-ssl.issuers["kubelet-client"].certificates["kubelet-client"].key-keeper-args.host_path}/kubelet-client.pem"
  kubelet-kubeconfig-client-key                             = "${local.kubernetes-ca-ssl.issuers["kubelet-client"].certificates["kubelet-client"].key-keeper-args.host_path}/kubelet-client-key.pem"

  kube-scheduler-kubeconfig-certificate-authority           = "${local.kubernetes-ca-ssl.host_path}/kubernetes-ca.pem"
  kube-scheduler-kubeconfig-client-certificate              = "${local.kubernetes-ca-ssl.issuers["kube-scheduler-client"].certificates["kube-scheduler-client"].key-keeper-args.host_path}/kube-scheduler-client.pem"
  kube-scheduler-kubeconfig-client-key                      = "${local.kubernetes-ca-ssl.issuers["kube-scheduler-client"].certificates["kube-scheduler-client"].key-keeper-args.host_path}/kube-scheduler-client-key.pem"

  kube-controller-manager-kubeconfig-certificate-authority  = "${local.kubernetes-ca-ssl.host_path}/kubernetes-ca.pem"
  kube-controller-manager-kubeconfig-client-certificate     = "${local.kubernetes-ca-ssl.issuers["kube-controller-manager-client"].certificates["kube-controller-manager-client"].key-keeper-args.host_path}/kube-controller-manager-client.pem"
  kube-controller-manager-kubeconfig-client-key             = "${local.kubernetes-ca-ssl.issuers["kube-controller-manager-client"].certificates["kube-controller-manager-client"].key-keeper-args.host_path}/kube-controller-manager-client-key.pem"

}


module "kube-apiserver-kubeconfig" {
    source = "../kubeconfig"
      component-name        = "kube-apiserver"
      certificate-authority = local.kube-apiserver-kubeconfig-certificate-authority
      client-certificate    = local.kube-apiserver-kubeconfig-client-certificate
      client-key            = local.kube-apiserver-kubeconfig-client-key
}

module "kubelet-kubeconfig" {
    source = "../kubeconfig"
      component-name        = "kubelet"
      certificate-authority = local.kubelet-kubeconfig-certificate-authority
      client-certificate    = local.kubelet-kubeconfig-client-certificate
      client-key            = local.kubelet-kubeconfig-client-key
}

module "kube-scheduler-kubeconfig" {
    source = "../kubeconfig"
      component-name        = "kube-scheduler"
      certificate-authority = local.kube-scheduler-kubeconfig-certificate-authority
      client-certificate    = local.kube-scheduler-kubeconfig-client-certificate
      client-key            = local.kube-scheduler-kubeconfig-client-key
}

module "kube-controller-manager-kubeconfig" {
    source = "../kubeconfig"
      component-name        = "kube-controller-manager"
      certificate-authority = local.kube-controller-manager-kubeconfig-certificate-authority
      client-certificate    = local.kube-controller-manager-kubeconfig-client-certificate
      client-key            = local.kube-controller-manager-kubeconfig-client-key
}


