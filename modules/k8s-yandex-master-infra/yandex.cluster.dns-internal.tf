#### INTERNAL DNS ZONE ######
##-->
resource "yandex_dns_zone" "cluster-external" {
  name             = local.cluster_name
  description      = "desc"
  zone             = "${local.base_cluster_fqdn}."
  public           = false
  private_networks = [data.yandex_vpc_network.cluster-vpc.id]
}

#### INTERNAL DNS FOR KUBE-APISERVER ######
##-->
resource "yandex_dns_recordset" "api-external" {
  zone_id = yandex_dns_zone.cluster-external.id
  name    = local.kube_apiserver_lb_fqdn
  type    = "A"
  ttl     = 60
  data    = local.kube_apiserver_lb_ip
}

#### INTERNAL DNS FRO ETCD DISCOVERY ######
##-->
resource "yandex_dns_recordset" "etcd-srv-server" {
  zone_id   = yandex_dns_zone.cluster-external.id
  name      = "_etcd-server-ssl._tcp.${local.base_cluster_fqdn}."
  type      = "SRV"
  ttl       = 60
  data      = local.etcd_member_servers_srv
}

resource "yandex_dns_recordset" "etcd-srv-client" {
  zone_id   = yandex_dns_zone.cluster-external.id
  name      = "_etcd-client-ssl._tcp.${local.base_cluster_fqdn}."
  type      = "SRV"
  ttl       = 60
  data      = local.etcd_member_clients_srv
}

