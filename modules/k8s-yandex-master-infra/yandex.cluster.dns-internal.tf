#### INTERNAL DNS ZONE ######
##-->
resource "yandex_dns_zone" "cluster-external" {
  name             = local.cluster_name
  zone             = local.base_cluster_dns_zone
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
# Включить, если требуется дискавери ETCD через SRV
# resource "yandex_dns_recordset" "etcd-srv-server" {
#   zone_id   = yandex_dns_zone.cluster-external.id
#   name      = local.etcd_srv_server_record
#   type      = "SRV"
#   ttl       = 60
#   data      = local.etcd_member_servers_srv
# }

# resource "yandex_dns_recordset" "etcd-srv-client" {
#   zone_id   = yandex_dns_zone.cluster-external.id
#   name      = local.etcd_srv_client_record
#   type      = "SRV"
#   ttl       = 60
#   data      = local.etcd_member_clients_srv
# }

