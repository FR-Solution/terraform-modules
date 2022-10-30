locals {
    manifest = flatten([
    for node_name, node_content in  var.k8s_global_vars.ssl_for_each_map["${var.instance_type}_instance_list_map"]:
        {"${node_name}" = templatefile("${path.module}/templates/kube-scheduler.yaml.tftpl", {
          ssl                     = var.k8s_global_vars.ssl
          kube_scheduler_image    = var.kube_scheduler_image
          kube_scheduler_version  = var.kube_scheduler_version
          base_path               = var.k8s_global_vars.global_path
    })}
    ])

    manifest-map = { for item in local.manifest :
      keys(item)[0] => values(item)[0]
    }
}
