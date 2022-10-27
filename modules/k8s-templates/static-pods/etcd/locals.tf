locals {
    manifest = flatten([
    for node_name, node_content in  var.k8s_global_vars.ssl_for_each_map["${var.instance_type}_instance_list_map"]:
        {"${node_name}" = templatefile("${path.module}/templates/etcd.yaml.tftpl", {
        base_local_path_certs           = var.k8s_global_vars.global_path.base_local_path_certs
        ssl                             = var.k8s_global_vars.ssl
        cluster_name                    = var.k8s_global_vars.cluster_name
        base_domain                     = var.k8s_global_vars.base_domain
        etcd_image                      = var.etcd_image
        etcd_version                    = var.etcd_version
        discovery_srv                   = var.k8s_global_vars.base_cluster_fqdn
        full_instance_name              = format("${node_name}.${var.k8s_global_vars.base_cluster_fqdn}")
        etcd_peer_port                  = var.k8s_global_vars.kubernetes-ports.etcd-peer-port
        etcd_server_port                = var.k8s_global_vars.kubernetes-ports.etcd-server-port
        etcd_metrics_port               = var.k8s_global_vars.kubernetes-ports.etcd-metrics-port
        etcd_server_port_target_lb      = var.k8s_global_vars.kubernetes-ports.etcd-server-port-target-lb
        data_dir                        = var.data_dir
    })}
    ])

    manifest-map = { for item in local.manifest :
      keys(item)[0] => values(item)[0]
    }
}
