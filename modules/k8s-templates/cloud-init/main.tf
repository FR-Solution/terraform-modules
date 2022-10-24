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
      })}
    ])
  }

