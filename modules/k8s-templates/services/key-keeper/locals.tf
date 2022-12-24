locals {
    key-keeper-config = flatten([
    for node_name, node_content in  var.instance_list_map:
        {"${node_name}" = templatefile("${path.module}/templates/config-all-approle-all.tftpl", {
            intermediates                   = var.k8s_global_vars.ssl.intermediate
            external_intermediates          = var.k8s_global_vars.ssl.external_intermediate
            secrets                         = var.k8s_global_vars.secrets
            base_path                       = var.k8s_global_vars.global_path
            base_certificate_atrs           = var.k8s_global_vars.ssl.global-args.key-keeper-args
            vault_config                    = var.k8s_global_vars.vault-config
            availability_zone               = node_name
            full_instance_name              = "${node_name}.${var.k8s_global_vars.base_cluster_fqdn}"
            base_cluster_fqdn               = "${var.k8s_global_vars.base_cluster_fqdn}"
            external_instance_name          = "${node_name}-${var.k8s_global_vars.cluster_name}"
            instance_type                   = var.instance_type
    })}
    ])
    key-keeper-config-map = { for item in local.key-keeper-config :
      keys(item)[0] => values(item)[0]
    }

    key-keeper-service                  = templatefile("${path.module}/templates/service.yaml.tftpl", {
        base_local_path_certs           = var.k8s_global_vars.global_path.base_local_path_certs
    })

}
