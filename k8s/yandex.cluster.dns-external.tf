#### EXTERNAL DNS FOR KUBE-APISERVER ######
##-->
resource "yandex_dns_recordset" "api" {
  zone_id = var.delegate_external_dns_zone
  name    = "${local.kube_apiserver_lb_fqdn}."
  type    = "A"
  ttl     = 60
  data    = "${(tolist(yandex_lb_network_load_balancer.api-internal.listener)[0].external_address_spec)[*].address}"
}
