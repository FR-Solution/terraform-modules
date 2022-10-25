locals {
    kubelet-config                    = templatefile("${path.module}/templates/config.yaml.tftpl", {
        ssl                           = var.k8s_global_vars.ssl
        kubelet-config-args           = local.kubelet-config-args
        base_static_pod_path          = var.k8s_global_vars.global_path.base_static_pod_path
        instance_type                 = var.instance_type
    })

    kubelet-service-args = flatten([
    for node_name, node_content in  var.k8s_global_vars.ssl_for_each_map["${var.instance_type}_instance_list_map"]:
      {"${node_name}" = templatefile("${path.module}/templates/service-args.conf.tftpl", {
        full_instance_name      = "${node_name}.${var.k8s_global_vars.base_cluster_fqdn}"
        instance_type           = var.instance_type
        base_kubernetes_path    = var.k8s_global_vars.global_path.base_kubernetes_path
        base_domain             = var.k8s_global_vars.base_domain
        })
      }]
    )

    kubelet-service-args-map = { for item in local.kubelet-service-args :
      keys(item)[0] => values(item)[0]
    }

    kubelet-service-d-fraima        = templatefile("${path.module}/templates/service.d/10-fraima.conf.tftpl",{
        base_kubernetes_path        = var.k8s_global_vars.global_path.base_kubernetes_path
    })
    kubelet-service                 = file("${path.module}/templates/service.tftpl")

    kubelet-config-args = {
      dns_address = var.k8s_global_vars.k8s-addresses.dns_address
    }
}