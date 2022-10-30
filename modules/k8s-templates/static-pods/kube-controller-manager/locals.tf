locals {
    manifest = flatten([
    for node_name, node_content in  var.k8s_global_vars.ssl_for_each_map["${var.instance_type}_instance_list_map"]:
        {"${node_name}" = templatefile("${path.module}/templates/kube-controller-manager.yaml.tftpl", {

        service_cidr                    = var.k8s_global_vars.service-cidr
        ssl                             = var.k8s_global_vars.ssl
        base_path                       = var.k8s_global_vars.global_path
        kube_controller_manager_image   = var.kube_controller_manager_image
        kube_controller_manager_version = var.kube_controller_manager_version

    })}
    ])

    manifest-map = { for item in local.manifest :
      keys(item)[0] => values(item)[0]
    }
}
