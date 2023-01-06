#### INTERNAL DNS ZONE ######
##-->
resource "yandex_dns_zone" "cluster-external" {
  name             = "dns-zone-${var.k8s_global_vars.cluster_name}"
  description      = "desc"
  zone             = "${var.k8s_global_vars.cluster_name}.${var.k8s_global_vars.base_domain}."
  public           = false
  private_networks = [var.master_group.vpc_id]
}

#### INTERNAL DNS FOR KUBE-APISERVER ######
##-->
resource "yandex_dns_recordset" "api-external" {
  zone_id = yandex_dns_zone.cluster-external.id
  name    = "${var.k8s_global_vars.k8s-addresses.kube_apiserver_lb_fqdn}."
  type    = "A"
  ttl     = 60
  data    = "${(tolist(yandex_lb_network_load_balancer.api-external.listener)[0].external_address_spec)[*].address}"
}

#### INTERNAL DNS FRO ETCD DISCOVERY ######
##-->
resource "yandex_dns_recordset" "etcd-srv-server" {
  zone_id   = yandex_dns_zone.cluster-external.id
  name      = "_etcd-server-ssl._tcp.${var.k8s_global_vars.cluster_name}.${var.k8s_global_vars.base_domain}."
  type      = "SRV"
  ttl       = 60
  data      = local.etcd_member_servers_srv
}

resource "yandex_dns_recordset" "etcd-srv-client" {
  zone_id   = yandex_dns_zone.cluster-external.id
  name      = "_etcd-client-ssl._tcp.${var.k8s_global_vars.cluster_name}.${var.k8s_global_vars.base_domain}."
  type      = "SRV"
  ttl       = 60
  data      = local.etcd_member_clients_srv
}

