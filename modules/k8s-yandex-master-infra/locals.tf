
locals {
  base_cluster_fqdn                 = var.k8s_global_vars.k8s-addresses.base_cluster_fqdn
  base_cluster_dns_zone             = "${local.base_cluster_fqdn}."
  
  extra_cluster_name                = var.k8s_global_vars.k8s-addresses.extra_cluster_name
  cluster_name                      = var.k8s_global_vars.cluster_metadata.cluster_name

  etcd_peer_port                    = var.k8s_global_vars.kubernetes-ports.etcd-peer-port
  etcd_server_port                  = var.k8s_global_vars.kubernetes-ports.etcd-server-port
  etcd_srv_server_record            = "_etcd-server-ssl._tcp.${local.base_cluster_fqdn}."
  etcd_srv_client_record            = "_etcd-client-ssl._tcp.${local.base_cluster_fqdn}."

  master_secondary_disk             = var.k8s_global_vars.master_vars.master_group.resources.disk.secondary_disk
  master_subnet_prefix_name         = "${local.cluster_name}-${var.k8s_global_vars.master_vars.master_group.name}"
  
  kube_apiserver_port_lb            = var.k8s_global_vars.kubernetes-ports.kube-apiserver-port-lb
  kube_apiserver_port               = var.k8s_global_vars.kubernetes-ports.kube-apiserver-port
  kube_apiserver_listener_name      = "api-listener-${local.cluster_name}"
  kube_apiserver_lb_name            = "api-loadbalancer${local.cluster_name}"
  kube_apiserver_lb_ip              = (tolist(yandex_lb_network_load_balancer.api-external.listener)[0].external_address_spec)[*].address
  kube_apiserver_lb_fqdn            = "${var.k8s_global_vars.k8s-addresses.kube_apiserver_lb_fqdn}."

  yandex_lb_target_group_master     = "${local.cluster_name}${data.yandex_vpc_network.cluster-vpc.id}"

  secret_id_all                     = var.k8s_vault_master.secret_id_all
  role_id_all                       = var.k8s_vault_master.role_id_all 

  user_data                         = module.k8s-cloud-init-master.cloud-init-render
}


locals {
  master_vars   = var.k8s_global_vars.master_vars
  master_group  = local.master_vars.master_group

  master_regexp = "${var.k8s_global_vars.master_vars.master_group.name}-\\d*"

  instances_disk = flatten([
  for disk_index, disk_name in keys(var.k8s_global_vars.master_vars.master_group.resources.disk.secondary_disk) : [
      for instance_name in var.k8s_global_vars.master_vars.master_instance_list:
        {"${disk_name}_${instance_name}" = {}}
        ]
      ]
  )
  instances_disk_map = { for item in local.instances_disk :
    keys(item)[0] => values(item)[0]
  }

  etcd_member_servers_srv = flatten([
    for master_index, master_value in var.k8s_global_vars.master_vars.master_instance_extra_list: [
     "0 0 ${local.etcd_peer_port} ${master_value}.${local.base_cluster_fqdn}."
    ]
  ])
  etcd_member_clients_srv = flatten([
    for master_index, master_value in var.k8s_global_vars.master_vars.master_instance_extra_list: [
     "0 0 ${local.etcd_peer_port} ${master_value}.${local.base_cluster_fqdn}."
    ]
  ])


  flatten_role_id_all = flatten([
      for index, value in local.role_id_all: [
      index
      ]
  ])

  set_role_id_all = toset(local.flatten_role_id_all)
  map_role_id_all = { for item in local.set_role_id_all :
      item => {}
  }

  flatten_secret_id_alls = flatten([
      for index, value in local.secret_id_all: [
      "${index}"
      ]
  ])

  set_secret_id_alls = toset(local.flatten_secret_id_alls)
  map_secret_id_alls = { for item in local.set_secret_id_alls :
      item => {}
  }

  subnets = flatten([
  for instance_name in keys(local.master_vars.master_instance_list_map) : 
        "${try(
        var.k8s_global_vars.master_vars.master_group.resources_overwrite[instance_name].network_interface.subnet,
        var.k8s_global_vars.master_vars.default_subnet
        )}:${try(
        var.k8s_global_vars.master_vars.master_group.resources_overwrite[instance_name].network_interface.zone,
        var.k8s_global_vars.master_vars.default_zone 
        )}"
      ]
  )
  subnets_set = toset(local.subnets)

  subnets_set_map = { for item in local.subnets_set :
      item => {}
  }

  cluster_external_instances_map = { for key, value in yandex_compute_instance.master :
      key => value.network_interface.0.nat_ip_address
  }
  cluster_internal_instances_map = { for key, value in yandex_compute_instance.master :
      key => value.network_interface[0].ip_address
  }

}
