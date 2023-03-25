module "firewall" {
  depends_on = [
    yandex_compute_instance.master,
  ]
    # source = "git::https://github.com/fraima/terraform-modules//modules/charlotte?ref=main"
    source = "../charlotte"
    security_groups = local.security_groups

}
