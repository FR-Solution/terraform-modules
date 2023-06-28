locals {
    manifest = flatten([
    for node_name, node_content in  var.instance_list_map:
        {"${node_name}" = templatefile("${path.module}/templates/etcd.yaml.tftpl", {
        base_local_path_certs             = var.k8s_global_vars.global_path.base_local_path_certs
        ssl                               = var.k8s_global_vars.ssl
        cluster_name                      = var.k8s_global_vars.cluster_metadata.cluster_name
        base_domain                       = var.k8s_global_vars.cluster_metadata.base_domain
        component_versions                = var.k8s_global_vars.component_versions
        discovery_srv                     = var.k8s_global_vars.k8s-addresses.base_cluster_fqdn
        full_instance_name                = format("${node_name}.${var.k8s_global_vars.k8s-addresses.base_cluster_fqdn}")
        etcd_peer_port                    = var.k8s_global_vars.kubernetes-ports.etcd-peer-port
        etcd_server_port                  = var.k8s_global_vars.kubernetes-ports.etcd-server-port
        etcd_metrics_port                 = var.k8s_global_vars.kubernetes-ports.etcd-metrics-port
        etcd_server_port_target_lb        = var.k8s_global_vars.kubernetes-ports.etcd-server-port-target-lb
        data_dir                          = var.data_dir
        etcd_initial_cluster              = var.etcd_initial_cluster
    })}
    ])

    manifest-map = { for item in local.manifest :
      keys(item)[0] => values(item)[0]
    }
}
