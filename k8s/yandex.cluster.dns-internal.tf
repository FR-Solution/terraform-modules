locals {
  etcd_member_servers_srv = flatten([
    for master_name, master_value in yandex_compute_instance.master: [
     "0 0 ${var.etcd-peer-port} ${var.master-configs.group}-${index(keys(yandex_compute_instance.master), master_name)}.${var.cluster_name}.${var.base_domain}."
    ]
  ])
  etcd_member_clients_srv = flatten([
    for master_name, master_value in yandex_compute_instance.master: [
     "0 0 ${var.etcd-server-port} ${var.master-configs.group}-${index(keys(yandex_compute_instance.master), master_name)}.${var.cluster_name}.${var.base_domain}."
    ]
  ])
}

#### INTERNAL DNS ZONE ######
##-->
resource "yandex_dns_zone" "cluster-external" {
  name             = "dns-zone-${var.cluster_name}"
  description      = "desc"
  zone             = "${var.cluster_name}.${var.base_domain}."
  public           = false
  private_networks = [yandex_vpc_network.cluster-vpc.id]
}

#### INTERNAL DNS FOR KUBE-APISERVER ######
##-->
resource "yandex_dns_recordset" "api-internal" {
  zone_id = yandex_dns_zone.cluster-external.id
  name    = "${local.kube_apiserver_lb_fqdn}."
  type    = "A"
  ttl     = 60
  data    = "${(tolist(yandex_lb_network_load_balancer.api-internal.listener)[0].external_address_spec)[*].address}"
}

#### INTERNAL DNS FOR ACCESS TO IDP ######
##-->
resource "yandex_dns_recordset" "auth-internal" {
  zone_id = yandex_dns_zone.cluster-external.id
  name    = "auth.dobry-kot.ru"
  type    = "A"
  ttl     = 60
  data    = ["193.32.219.99"]
}


#### INTERNAL DNS FRO ETCD DISCOVERY ######
##-->
resource "yandex_dns_recordset" "etcd-srv-server" {
  zone_id   = yandex_dns_zone.cluster-external.id
  name      = "_etcd-server-ssl._tcp.${var.cluster_name}.${var.base_domain}."
  type      = "SRV"
  ttl       = 60
  data      = local.etcd_member_servers_srv
}

resource "yandex_dns_recordset" "etcd-srv-client" {
  zone_id   = yandex_dns_zone.cluster-external.id
  name      = "_etcd-client-ssl._tcp.${var.cluster_name}.${var.base_domain}."
  type      = "SRV"
  ttl       = 60
  data      = local.etcd_member_clients_srv
}

