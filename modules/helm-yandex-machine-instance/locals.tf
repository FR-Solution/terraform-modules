locals {
  base_values =  yamldecode(templatefile("${path.module}/helm/values.yaml.tftpl", {
    k8s_api_server_fqdn   = var.global_vars.k8s-addresses.kube_apiserver_lb_fqdn
    k8s_api_server_port   = var.global_vars.kubernetes-ports.kube-apiserver-port-lb
    resolved              = true
    subnet_id             = try(var.custom_values.subnet_id, "")
    zone                  = try(var.custom_values.zone, "") 
    image_id              = try(var.custom_values.image_id, "")
    replicas              = try(var.custom_values.replicas, 0)
    provider_secret_name  = var.release_name
    ssh_username          = var.global_vars.base.ssh_username
    ssh_key               = file(var.global_vars.base.ssh_rsa_path)
  }))

  merge_values = merge(local.base_values, var.extra_values)
}
