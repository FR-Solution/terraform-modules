output "kube-apiserver-lb" {
  value = tolist(tolist(yandex_lb_network_load_balancer.api-external.listener)[0].external_address_spec)[0].address
}

output "master_cidr_list" {
  value = flatten([
    for compute in yandex_compute_instance.master:
      "${compute.network_interface[0].ip_address}/32"
    ])
}

output "master_instance_list_map" {
  value = local.master_instance_list_map
}

output "yandex_compute_instance_master" {
  value = yandex_compute_instance.master
}

output "cluster_external_instances_map" {
  value = local.cluster_external_instances_map
}

output "cluster_internal_instances_map" {
  value = local.cluster_internal_instances_map
}