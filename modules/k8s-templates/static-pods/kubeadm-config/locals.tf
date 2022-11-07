locals {
    manifest = flatten([
    for node_name, node_content in  var.k8s_global_vars.ssl_for_each_map["${var.instance_type}_instance_list_map"]:
        {"${node_name}" = templatefile("${path.module}/templates/kubeadm-config.yaml.tftpl", {
        
        etcd_list_servers                             = var.k8s_global_vars.etcd_list_servers
        secrets                         = var.k8s_global_vars.secrets
        etcd_advertise_client_urls      = var.k8s_global_vars.k8s-addresses.etcd_advertise_client_urls
        service_cidr                    = var.k8s_global_vars.service-cidr
        ssl                             = var.k8s_global_vars.ssl
        kubernetes_version              = var.kubernetes_version
        base_path                       = var.k8s_global_vars.global_path
        kube_apiserver_port             = var.k8s_global_vars.kubernetes-ports.kube-apiserver-port
        kube_api_fqdn                   = var.k8s_global_vars.k8s-addresses.kube_apiserver_lb_fqdn

    })}
    ])

    manifest-map = { for item in local.manifest :
      keys(item)[0] => values(item)[0]
    }
}
