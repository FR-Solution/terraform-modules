module "cilium" {
    count = try(var.global_vars.addons.cilium.enabled, false) == true ? 1 : 0

    source = "../helm-yandex-cilium"
    depends_on = [
        module.yandex-cloud-controller,
    ]
    chart_version       = "1.12.6"

    global_vars         = module.k8s-global-vars
    extra_values        = try(var.global_vars.addons.cilium.extra_values, {})
}

module "yandex-cloud-controller" {
    count = try(var.global_vars.addons.yandex-cloud-controller.enabled, false) == true ? 1 : 0

    source = "../helm-yandex-cloud-controller"
    depends_on = [
        module.k8s-ready-status
    ]
    chart_version = "0.0.7"

    yandex_default_vpc_name         = var.master_group.vpc_name
    yandex_default_route_table_name = var.master_group.route_table_name
    namespace                       = "kube-fraima-yandex-cloud-controller"

    global_vars = module.k8s-global-vars

    extra_values = try(var.global_vars.addons.yandex-cloud-controller.extra_values, {})
}

module "yandex-csi-controller" {
    count = try(var.global_vars.addons.yandex-csi-controller.enabled, false) == true ? 1 : 0

    source = "../helm-yandex-csi-controller"

    depends_on = [
        module.cilium
    ]

    namespace           = "kube-fraima-yandex-csi-controller"

    chart_version       = "0.0.8"
    global_vars         = module.k8s-global-vars
    extra_values = try(var.global_vars.addons.yandex-csi-controller.extra_values, {})
}

module "coredns" {
    count = try(var.global_vars.addons.coredns.enabled, false) == true ? 1 : 0

    source = "../helm-coredns"
    depends_on = [
        module.cilium,
    ]
    chart_version       = "1.19.4"

    global_vars         = module.k8s-global-vars
    extra_values        = try(var.global_vars.addons.coredns.extra_values, {})
}

module "gatekeeper" {
    count = try(var.global_vars.addons.gatekeeper.enabled, false) == true ? 1 : 0

    source = "../helm-gatekeeper"
    depends_on = [
        module.coredns,
    ]

    global_vars         = module.k8s-global-vars
    extra_values        = try(var.global_vars.addons.gatekeeper.extra_values, {})
}

module "certmanager" {
    count = try(var.global_vars.addons.certmanager.enabled, false) == true ? 1 : 0

    source = "../helm-certmanager"
    depends_on = [
        module.gatekeeper,
    ]

    global_vars         = module.k8s-global-vars
    extra_values        = try(var.global_vars.addons.certmanager.extra_values, {})
}

module "vault-issuer" {
    count = try(var.global_vars.addons.vault-issuer.enabled, false) == true ? 1 : 0

    source = "../k8s-vault-issuer"
    depends_on = [
        module.certmanager,
        module.gatekeeper,
    ]

    global_vars = module.k8s-global-vars

}

