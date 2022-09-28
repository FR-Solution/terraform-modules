
#### MASTERS ######
##-->
resource "yandex_compute_instance" "master" {

  for_each    = "${var.availability_zones}"
  name        = "${var.master-configs.group}-${index(keys(var.availability_zones), each.key)}-${var.cluster_name}"
  hostname    = format("%s-%s.%s.%s",var.master-configs.group, index(keys(var.availability_zones), each.key),var.cluster_name, var.base_domain)
  platform_id = "standard-v1"
  zone        = "${each.key}"

  resources {
    cores         = "${var.master_flavor.core}"
    memory        = "${var.master_flavor.memory}"
    core_fraction = "${var.master_flavor.core_fraction}"
  }

  boot_disk {
    initialize_params {
      image_id = "${var.base_os_image}"
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.cluster-subnet[each.key].id}"
    nat = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
    user-data = templatefile("templates/cloud-init-master.tftpl", {

        ssh_key                           = file("~/.ssh/id_rsa.pub")
        base_local_path_certs             = local.base_local_path_certs
        ssl                               = local.ssl
        base_path                         = var.base_path

        key_keeper_config                 = templatefile("templates/services/key-keeper/config.tftpl", {
          availability_zone               = each.key
          intermediates                   = local.ssl.intermediate
          base_local_path_vault           = local.base_local_path_vault
          base_vault_path_approle         = local.base_vault_path_approle
          base_certificate_atrs           = local.ssl.global-args.key-keeper-args
          secrets                         = local.secrets
          cluster_name                    = var.cluster_name
          base_domain                     = var.base_domain
          vault_config                    = var.vault_config
          vault_server                    = var.vault_server
          bootstrap_tokens_ca             = vault_token.kubernetes-ca-login
          bootstrap_tokens_sign           = vault_token.kubernetes-sign-login
          bootstrap_tokens_kv             = vault_token.kubernetes-kv-login
          availability_zone               = each.key
          instance_name                   = format("%s-%s.%s",var.master-configs.group, index(keys(var.availability_zones), each.key),var.cluster_name)
        })
        kubelet-service-args              = templatefile("templates/services/kubelet/service-args.conf.tftpl", {
          instance_name                   = format("%s-%s.%s",var.master-configs.group, index(keys(var.availability_zones), each.key),var.cluster_name)
          instance_type                   = var.master-configs.group
          base_path                       = var.base_path
          base_domain                     = var.base_domain
        })
        etcd-manifest                     = templatefile("templates/manifests/etcd.yaml.tftpl", {
          etcd_initial_cluster            = local.etcd_initial_cluster
          base_local_path_certs           = local.base_local_path_certs
          ssl                             = local.ssl
          cluster_name                    = var.cluster_name
          base_domain                     = var.base_domain
          etcd-image                      = var.etcd-image.repository
          etcd-version                    = var.etcd-image.version
          instance_name                   = format("%s-%s",var.master-configs.group, index(keys(var.availability_zones), each.key))
        })

        kube-apiserver-manifest           = local.kube-apiserver-manifest
        kube-controller-manager-manifest  = local.kube-controller-manager-manifest 
        kube-scheduler-manifest           = local.kube-scheduler-manifest
        kubelet-service-d-fraima          = local.kubelet-service-d-fraima
        containerd-service                = local.containerd-service
        base-cni                          = local.base-cni
        sysctl-network                    = local.sysctl-network
        kubelet-config                    = local.kubelet-config
        kubelet-service                   = local.kubelet-service
        key-keeper-service                = local.key-keeper-service
        modules-load-k8s                  = local.modules-load-k8s
      })
  }
}

output "cloud_init" {
    value = "${yandex_compute_instance.master[*].ru-central1-a.network_interface[*].nat_ip_address}"
}


output "LB-API" {
    value = "${tolist(tolist(yandex_lb_network_load_balancer.master-lb.listener)[0].external_address_spec)[0].address}"
}
