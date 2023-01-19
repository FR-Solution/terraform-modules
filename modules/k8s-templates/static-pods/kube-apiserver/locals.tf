locals {
    manifest = flatten([
    for node_name, node_content in var.instance_list_map:
        {"${node_name}" = templatefile("${path.module}/templates/kube-apiserver.yaml.tftpl", {

        secrets                         = var.k8s_global_vars.secrets
        etcd_advertise_client_urls      = var.etcd_advertise_client_urls
        service_cidr                    = var.k8s_global_vars.k8s_network.service_cidr
        ssl                             = var.k8s_global_vars.ssl
        oidc_issuer_url                 = var.oidc_issuer_url
        oidc_client_id                  = var.oidc_client_id
        kube_apiserver_image            = var.kube_apiserver_image
        kube_apiserver_image_version    = var.kube_apiserver_image_version
        base_path                       = var.k8s_global_vars.global_path
        main_path                       = var.k8s_global_vars.main_path
        kube_apiserver_port             = var.k8s_global_vars.kubernetes-ports.kube-apiserver-port
        

    })}
    ])

    manifest-map = { for item in local.manifest :
      keys(item)[0] => values(item)[0]
    }

    kube-apiserver-audit = file("${path.module}/templates/audit.yaml.tftpl")
}
