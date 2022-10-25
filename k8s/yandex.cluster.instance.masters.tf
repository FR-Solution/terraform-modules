#### MASTERS ######
##-->
resource "yandex_compute_instance" "master" {

  for_each    = local.master_instance_list_map

  name        = "${each.key}-${var.cluster_name}"

  hostname    = format("%s.%s.%s", each.key ,var.cluster_name, var.base_domain)
  platform_id = "standard-v1"
  zone        = var.master-configs.zone
  labels      = {
    "node-role.kubernetes.io/master" = ""
  }
  resources {
    cores         = var.master_flavor.core
    memory        = var.master_flavor.memory
    core_fraction = var.master_flavor.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = var.base_os_image
      size = 20
    }
  }

  secondary_disk {
    disk_id = yandex_compute_disk.etcd[each.key].id
    auto_delete = false
    mode = "READ_WRITE"
    device_name = "etcd-data"
  }

  service_account_id = yandex_iam_service_account.master-sa[each.key].id

  network_interface {
    subnet_id = yandex_vpc_subnet.master-subnets.id
    nat = true
  }

  lifecycle {
    ignore_changes = [
      metadata
    ]
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
    user-data = templatefile("templates/cloud-init-master.tftpl", {

        ssh_key                           = file("~/.ssh/id_rsa.pub")
        base_local_path_certs             = local.global_path.base_local_path_certs
        ssl                               = local.ssl
        base_path                         = var.base_path
        kube_apiserver_lb_fqdn            = local.kube_apiserver_lb_fqdn
        kube-apiserver-port-lb            = var.kube-apiserver-port-lb
        hostname                          = "${each.key}-${var.cluster_name}"
        
        bootstrap_token_all               = module.k8s-vault.bootstrap-master-token[each.key].client_token
        release-vars                      = local.release-vars
        actual-release                    = var.actual-release
        key_keeper_config                 = templatefile("templates/services/key-keeper/config.tftpl", {
          intermediates                   = local.ssl.intermediate
          external_intermediates          = local.ssl.external_intermediate
          secrets                         = local.secrets
          base_local_path_vault           = local.base_local_path_vault
          base_vault_path_approle         = local.global_path.base_vault_path_approle
          base_certificate_atrs           = local.ssl.global-args.key-keeper-args
          cluster_name                    = var.cluster_name
          base_domain                     = var.base_domain
          vault_config                    = var.vault_config
          vault_server                    = var.vault_server
          bootstrap_token_all             = module.k8s-vault.bootstrap-master-token[each.key].client_token
          availability_zone               = each.key
          full_instance_name              = format("%s.%s", each.key ,local.base_cluster_fqdn)
          external_instance_name          = "${each.key}-${var.cluster_name}"
          instance_type                   = "master"
        })

        etcd-manifest                     = templatefile("templates/manifests/etcd.yaml.tftpl", {
          etcd_initial_cluster            = local.etcd_initial_cluster
          base_local_path_certs           = local.global_path.base_local_path_certs
          ssl                             = local.ssl
          cluster_name                    = var.cluster_name
          base_domain                     = var.base_domain
          etcd-image                      = local.release-vars[var.actual-release].etcd.registry
          etcd-version                    = local.release-vars[var.actual-release].etcd.version
          full_instance_name              = format("%s.%s", each.key ,local.base_cluster_fqdn)
          etcd-peer-port                  = var.etcd-peer-port
          etcd-server-port                = var.etcd-server-port
          etcd-metrics-port               = var.etcd-metrics-port
          etcd-server-port-target-lb      = var.etcd-server-port-target-lb
        })
        kubelet-config                    = templatefile("templates/services/kubelet/config.yaml.tftpl", {
            ssl                           = local.ssl
            kubelet-config-args           = local.kubelet-config-args
            base_path                     = var.base_path
            instance_type                 = "master"
        })
        kubelet-service-args              = templatefile("templates/services/kubelet/service-args.conf.tftpl", {
          full_instance_name              = format("%s.%s", each.key ,local.base_cluster_fqdn)
          instance_type                   = var.master-configs.group
          base_path                       = var.base_path
          base_domain                     = var.base_domain
        })
        kubelet-service                   = local.kubelet-service
        kubelet-service-d-fraima          = local.kubelet-service-d-fraima
        kube-apiserver-manifest           = local.kube-apiserver-manifest
        kube-controller-manager-manifest  = local.kube-controller-manager-manifest 
        kube-scheduler-manifest           = local.kube-scheduler-manifest
        
        containerd-service                = local.containerd-service
        base-cni                          = local.base-cni
        sysctl-network                    = local.sysctl-network
        
        key-keeper-service                = local.key-keeper-service
        modules-load-k8s                  = local.modules-load-k8s
      })
  }
}

output "cloud_init" {
    value = "${yandex_compute_instance.master[*].master-1.network_interface[*].nat_ip_address}"
}
