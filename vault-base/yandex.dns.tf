
resource "yandex_dns_recordset" "auth" {
  zone_id = "dns140h7j2l3gcjchb1v"
  name    = "auth.dobry-kot.ru"
  type    = "A"
  ttl     = 60
  data    = ["193.32.219.99"]
}

resource "yandex_dns_recordset" "vault" {
  zone_id = "dns140h7j2l3gcjchb1v"
  name    = "vault.dobry-kot.ru"
  type    = "A"
  ttl     = 60
  data    = ["193.32.219.99"]
}