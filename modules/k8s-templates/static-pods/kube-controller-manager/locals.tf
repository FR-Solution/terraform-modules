locals {
    manifest = flatten([
    for node_name, node_content in  var.instance_list_map:
        {"${node_name}" = templatefile("${path.module}/templates/kube-controller-manager.yaml.tftpl", {
        secrets                         = var.k8s_global_vars.secrets
        service_cidr                    = var.k8s_global_vars.k8s_network.service_cidr
        ssl                             = var.k8s_global_vars.ssl
        base_path                       = var.k8s_global_vars.global_path
        main_path                       = var.k8s_global_vars.main_path 
        kube_controller_manager_image   = var.kube_controller_manager_image
        kube_controller_manager_version = var.kube_controller_manager_version

    })}
    ])

    manifest-map = { for item in local.manifest :
      keys(item)[0] => values(item)[0]
    }
}
